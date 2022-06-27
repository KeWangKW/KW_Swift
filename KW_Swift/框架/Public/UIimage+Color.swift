//
//  UIimage+Color.swift
//  KW_Swift
//
//  Created by Yinjoy on 2021/4/17.
//  Copyright © 2021 guan. All rights reserved.
//

import Foundation

public func getImageWithColor(color:UIColor)->UIImage{
    let rect = CGRect(x: 0, y: 0, width: KScreenWidth, height: KNavigationStatusHeight)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
