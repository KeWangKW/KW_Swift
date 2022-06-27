//
//  BHomeApi.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/5/10.
//  Copyright © 2021 guan. All rights reserved.
//

import Foundation
import Moya

let BHomeReq = ApiProvider<BHomeApi>()

enum BHomeApi{
    case getHomeData(params:[String:Any])
    
}

extension BHomeApi: ApiTargetType {
    
    var baseURL: URL { //服务器地址
        return URL(string: Api.baseApi)!
    }
    
    var path: String { //请求路径
        
        switch self {
        case .getHomeData:
            return "v9/Home/getHomeData"
        }
    }
    
//    var showLoading: Loading {
//        switch self {
//        case
//                .getHomeData:
//            return .none
//        default:
//            return .normal
//        }
//    }
    
    var method: Moya.Method { //请求方式
        return .post
    }
    
    var task: Task {
        let encoding: ParameterEncoding = JSONEncoding.default
        
        
        switch self {
        case .getHomeData(let params):
            return .requestParameters(parameters: params, encoding: encoding)
        
        }
    }
    
    var headers: [String : String]? {
        let token = UserDefaults.LoginInfo.value(forKey: .tokenXDS_B) as? String ?? ""
        let nowToken = String(format: "%@2333", token)
        print("token："+nowToken)
        
        return ["Content-type": "application/json" ,
                "token": nowToken ,"x-application-version": App.version ,"scene":"IOS" ]
    }
    
    var validate: Bool {
        return false
    }
}

