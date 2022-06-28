//
//  ZApprovalApi.swift
//  KW_Swift
//
//  Created by bingxin on 2021/1/8.
//  Copyright © 2021 guan. All rights reserved.
//

import Foundation
let ZApprovalProvider = MoyaProvider<ZApprovalApi>(plugins : [ NetworkLoggerPlugin()]) //
enum ZApprovalApi {
    case approveTodo(userId:String)
    case readAllMsg(userId:String)
    
    case overTimes(userId:String,content:String,current:String,size:String)
    case atMe(userId:String,content:String,current:String,size:String)
    case expensess(userId:String,content:String,current:String,size:String)
    case cash(userId:String,content:String,current:String,size:String)
    case purchase(userId:String,content:String,current:String,size:String)
    case goods(userId:String,content:String,current:String,size:String)
    case payment(userId:String,content:String,current:String,size:String)
    case join(userId:String,content:String,current:String,size:String)
    case leave(userId:String,content:String,current:String,size:String)
    
    case officialseals(userId:String,content:String,current:String,size:String)
    
    case car(userId:String,content:String,current:String,size:String)
    case reclock(userId:String,content:String,current:String,size:String)
}

extension ZApprovalApi : TargetType {
    var baseURL: URL {
        switch self {
        case .approveTodo(let userId) , .readAllMsg(let userId) :
            
            return URL(string: String(format: "%@?userId=\(userId)", Api.baseApi))!
            
            
        case .overTimes(let userId, let content, let current, let size)
            , .atMe(let userId, let content, let current, let size)
            , .expensess(let userId, let content, let current, let size)
            , .cash(let userId, let content, let current, let size)
            , .purchase(let userId, let content, let current, let size)
            , .goods(let userId, let content, let current, let size)
            , .payment(let userId, let content, let current, let size)
            , .join(let userId, let content, let current, let size)
            , .leave(let userId, let content, let current, let size)
            , .officialseals(let userId, let content, let current, let size)
            , .car(let userId, let content, let current, let size)
            , .reclock(let userId, let content, let current, let size)
        
        :
            let newContent = content.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
            return URL(string: String(format: "%@?userId=\(userId)&content=\(newContent ?? "")&size=\(size)&current=\(current)", Api.baseApi))!
        }
    }
    
    var path: String {
        switch self {
        case .approveTodo:
            return Api.approveTodo
       
        case .readAllMsg(let userId):
            return Api.readAllMsg + "/\(userId)"
        case .overTimes:
            return Api.overTimes
        case .atMe:
            return Api.atMe
        case .expensess:
            return Api.expensess
        case .cash:
            return Api.cash
        case .purchase:
            return Api.purchase
        case .goods:
            return Api.goods
        case .payment:
            return Api.payment
        case .join:
            return Api.join
        case .leave:
            return Api.leave
        case .officialseals:
            return Api.officialseals
        case .car:
            return Api.car
        case .reclock:
            return Api.reclock
            
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case .approveTodo,.overTimes,.atMe,.expensess,.cash:
//            return .get
        case .readAllMsg:
            return .put
        default :
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
//        switch self {
//        case .approveTodo , .readAllMsg,.overTimes:
//
//
//        }
    }
    
    var headers: [String : String]? {
        let token = UserDefaults.LoginInfo.value(forKey: .token) as? String ?? ""
        let nowToken = String(format: "Bearer %@", token)
        
        return ["Content-type": "application/json" ,
                "Authorization": nowToken]
    }
    
    
}
