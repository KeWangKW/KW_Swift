//
//  KWModel.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/22.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation

#if canImport(HandyJSON)
@_exported import HandyJSON

class KWModel: NSObject, HandyJSON {
    public required override init() {}
    
    func mapping(mapper: HelpingMapper) { }
    func didFinishMapping() { }
}


// MARK: - Json to model
extension KWModel {
    
    static func toModel(_ list: NSDictionary?) -> Self? {
        guard let list = list else { return nil }
        return Self.deserialize(from: list)
    }
    
    static func toModels(_ lists: NSArray?) -> [KWModel]? {
        guard let lists = lists else { return nil }
        return [Self].deserialize(from: lists) as? [Self]
    }
    
    static func toModels<T: KWModel>(_ lists: Any?) -> [T]? {
        return [Self].deserialize(from: lists as? NSArray) as? [T]
    }
}

#else
class KWModel: NSObject { }
#endif


