//
//  ApiProvider.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/17.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import Moya

/// 请求返回数据回调
typealias ApiCompletion = (_ result: Result<ApiResponse, ApiError>) -> Void

/// 进度条回调
typealias ApiProgressBlock = (_ progress: Double) -> Void



/// 自定义 Provider
/// 内部声明一个Moya的provider
///
public struct ApiProvider<Target: ApiTargetType> {
    let provider: MoyaProvider<Target>
    init(provider: MoyaProvider<Target> = defaultProvider()) {
        self.provider = provider
    }
}


extension ApiProvider {
    @discardableResult
    func request(_ target: Target, completion: @escaping ApiCompletion) -> Cancellable {
        return request(target, progress: .none, completion: completion)
    }
    
    func requestWithProgress(_ target: Target, progress: @escaping ApiProgressBlock ,completion: @escaping ApiCompletion) -> Cancellable {
        return request(target, progress: progress, completion: completion)
    }
    
    @discardableResult
    func request(_ target: Target, progress: ApiProgressBlock?, completion: @escaping ApiCompletion) -> Cancellable {
        return provider.request(target, callbackQueue: .none, progress: { progress?($0.progress) }) { (result) in
            switch result {
            case let .success(response):
                let resp = ApiResponse(response)
                completion(.success(resp))
            case let .failure(error):
                let error = ApiError.transform(error)
                HUD.showError(text: error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    
}


// MARK: - default
extension ApiProvider {
    
    public static func defaultProvider() -> MoyaProvider<Target> {
        return MoyaProvider(
            endpointClosure: ApiProvider.defaultEndpointClosure,
            requestClosure: ApiProvider.defaultRequestClosure,
            plugins: defaultPlugin
        )
    }
    
    public static func defaultEndpointClosure(target: Target) -> Endpoint {
        let url = target.baseURL.absoluteString + target.path
        var task = target.task
        
        if let token = UserDefaults.LoginInfo.value(forKey: .tokenXDS_B) as? String,
            (target as ApiTargetType).useToken {
            let tokenParameters = ["token": token]
            var parameters = target.parameters ?? [:]
            tokenParameters.forEach{ parameters[$0.key] = $0.value }

            let defaultEncoding = URLEncoding.default
            switch task {
            case .requestPlain:
                task = .requestParameters(parameters: parameters, encoding: defaultEncoding)
            case .requestParameters(_, let encoding):
                task = .requestParameters(parameters: parameters, encoding: encoding)
            case .uploadMultipart(let data):
                task = .uploadCompositeMultipart(data, urlParameters: parameters)
            case .uploadCompositeMultipart(let data, _):
                task = .uploadCompositeMultipart(data, urlParameters: parameters)
            default:
                break
            }
        }
        
        return Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: task,
            httpHeaderFields: target.headers
        )
    }
    
    public static func defaultRequestClosure(endpoint: Endpoint, closure: MoyaProvider<Target>.RequestResultClosure) {
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = TimeInterval(TIMEOUTINTERVAL)
            
            /// 打印请求参数
            #if DEBUG
            print("")
            print("↓↓↓↓↓↓↓↓↓↓  网络请求-请求体  ↓↓↓↓↓↓↓↓↓↓")
            print("### URL:\n" + "\(request.url!)")
            print("### Method:\n" + "\(String(describing: request.method))")
            if let body = request.httpBody {
                print("### Parameters: \n" + "\(String(data: body, encoding: .utf8) ?? "")")
            }
            print("↑↑↑↑↑↑↑↑↑↑  网络请求-请求体  ↑↑↑↑↑↑↑↑↑↑")
            print("")
            #endif
            
            closure(.success(request))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    /// 自定义插件
    /// 加载动画在此处呈现
    public static var defaultPlugin: [PluginType] {
        let plugin = NetworkActivityPlugin { (changeType, target) in
            /** changeType：.begin 在子线程，.ended在主线程 */
            
            let target = target as! ApiTargetType
            switch changeType {
            case.began:
                DispatchQueue.main.async {
                    let view = target.loadingInView
                    switch target.showLoading {
                    case .normal:
                        HUD.show(view: view)
                    case .opaque:
                        HUD.show(view: view, text: nil, opaque: true, offset: .zero)
                    case .text(let text):
                        HUD.show(view: view, text: text, opaque: false, offset: .zero)
                    case .none: break
                    }
                }
                break
            case .ended:
                if case .none = target.showLoading {
                    break
                }
                HUD.hideIndeterminate(target.loadingInView)
            }
        }
        return [plugin]
    }
}


/**
/// 自定义Endpoint 配置对应参数
public let ApiEndPointClosure = { (target: TargetType) -> Endpoint in
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    
    let token = "xx"
    if token != nil {
        let tokenParameters = ["token": token]
        let defaultEncoding = URLEncoding.default
        switch task {
        case .requestPlain:
            task = .requestParameters(parameters: tokenParameters, encoding: defaultEncoding)
        case .requestParameters(var parameters, let encoding):
            tokenParameters.forEach{ parameters[$0.key] = $0.value }
            task = .requestParameters(parameters: parameters, encoding: encoding)
        case .uploadMultipart(let data):
            task = .uploadCompositeMultipart(data, urlParameters: tokenParameters)
        case .uploadCompositeMultipart(let data, urlParameters: var parameters):
            tokenParameters.forEach{ parameters[$0.key] = $0.value }
            task = .uploadCompositeMultipart(data, urlParameters: tokenParameters)
        default:
            break
        }
    }
    
    return Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
}


/// 自定义网络请求设置
public let ApiRequestClosure = { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = TimeInterval(TIMEOUTINTERVAL)
        
        /// 打印请求参数
        print("##########  网络请求  ##########")
        print("### URL:" + "\n" + "\(request.url!)")
        print("### Method:" + "\n" + "\(String(describing: request.method))")
        if let body = request.httpBody {
            print("###Parameters:" + "\n" + "\(String(data: body, encoding: .utf8) ?? "")")
        }
        closure(.success(request))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
}

 */
