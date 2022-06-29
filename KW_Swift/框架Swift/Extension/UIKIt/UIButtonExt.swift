//
//  UIButtonExt.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/26.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit



public extension KWSwiftWrapper where Base: UIButton {
    
    enum Position {
        case top, left, bottom, right
    }
    
    func set(image position: Position = .left, spacing: CGFloat) {
        base.layoutIfNeeded()
        
        guard
            let imageWidth = base.imageView?.frame.width,
            let imageHeight = base.imageView?.frame.height,
            let labelWidth = base.titleLabel?.frame.width,
            let labelHeight = base.titleLabel?.frame.height
        else { return }
        
        let space = spacing
        var imageInsets = UIEdgeInsets.zero
        var labelInsets = UIEdgeInsets.zero
        
        switch position {

        case .top:
            imageInsets = UIEdgeInsets.init(top: -(labelHeight + space) / 2, left: labelWidth / 2, bottom: (labelHeight + space) / 2, right: -labelWidth / 2 )
            labelInsets = UIEdgeInsets.init(top: (imageHeight + space) / 2, left: -imageWidth / 2, bottom: -(imageHeight + space) / 2, right: imageWidth / 2)
            break
        case .left:
            imageInsets = UIEdgeInsets(top: 0, left: -space, bottom: 0, right: space)
            labelInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: -space)
            break
        case .bottom:
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -(labelHeight + space / 2), right: -labelWidth)
            labelInsets = UIEdgeInsets(top: -(imageHeight + space / 2), left: -imageWidth, bottom: 0, right: 0)
            break
        case .right:
            imageInsets = UIEdgeInsets(top: 0, left: labelWidth + space, bottom: 0, right: -(labelWidth + space))
            labelInsets = UIEdgeInsets(top: 0, left: -(imageWidth + space), bottom: 0, right: imageWidth + space)
            break
        }
        
        base.imageEdgeInsets = imageInsets
        base.titleEdgeInsets = labelInsets
    }
    
}
