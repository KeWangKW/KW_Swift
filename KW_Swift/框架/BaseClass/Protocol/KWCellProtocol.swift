//
//  KWCellProtocol.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/2.
//  Copyright © 2020 渴望. All rights reserved.
//

import Foundation
import UIKit
//import ObjectMapper

protocol KWCellItemProtocol {
    associatedtype T
    
    var cellIdentifier: String { get }
    var cellClass: T.Type { get }
    var cellModel: KWModel? { get set }
    var selector: Selector? { get set }
    
    init(model: KWModel?)
    
    var title: String? { get set }
    var imageName: String? { get set }
}



@objc protocol KWTableViewCellDelegate {
    @objc optional func kw_responseViewInCell(_ cell: KWTableViewCell, object: Any?)
}

@objc protocol KWCollectionViewCellDelegate {
    @objc optional func kw_responseViewInCell(_ cell: KWCollectionViewCell, object: Any?)
}
