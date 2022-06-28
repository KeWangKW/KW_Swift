//
//  UIImageViewExt.swift
//  Whatever
//
//  Created by 渴望 on 2020/7/17.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

public extension KWSwiftWrapper where Base: UIImageView {
    
    func scaleAspectFill() {
        base.contentMode = .scaleAspectFill
        base.clipsToBounds = true
    }
    
}
