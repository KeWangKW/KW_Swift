//
//  BPDModel.swift
//  KW_Swift
//
//  Created by 渴望 on 2022/6/27.
//  Copyright © 2022 guan. All rights reserved.
//

import UIKit

class BPDModel: KWModel {
    var pageCount:String = "200"
    var data:[BPDDDModel] = []
}

class BPDDDModel: KWModel {
    var name:String = ""
}
