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
//            let imageWidth = base.imageView?.frame.width,
//            let imageHeight = base.imageView?.frame.height,
//            let titleWidth = base.titleLabel?.frame.width,
//            let titleHeight = base.titleLabel?.frame.height
            let imageWidth = base.imageView?.frame.width,
            let imageHeight = base.imageView?.frame.height,
            let labelWidth = base.titleLabel?.frame.width,
            let labelHeight = base.titleLabel?.frame.height
        else { return }
        
//        let space = spacing * 0.5
//
//        let imageOffsetX = (imageWidth + titleWidth) / 2 - imageWidth / 2
//        let imageOffsetY = imageHeight / 2 + space
//        let titleOffsetX = (imageWidth + titleWidth / 2) - (imageWidth + titleWidth) / 2
//        let titleOffsetY = titleHeight / 2 + spacing
        let space = spacing
        var imageInsets = UIEdgeInsets.zero
        var labelInsets = UIEdgeInsets.zero
        
        switch position {
//        case .left:
//            base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space, bottom: 0, right: space)
//            base.titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: -space)
//        case .right:
//            base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(space + imageWidth), bottom: 0, right: imageWidth)
//            base.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth, bottom: 0, right: -(space + titleWidth))
//        case .above:
//            base.imageEdgeInsets = UIEdgeInsets(top: -titleHeight-space/2, left: 0, bottom: 0, right: -titleWidth)
//            base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-space/2, right: 0)
//
//        case .bottom:
//            base.imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
//            base.titleEdgeInsets = UIEdgeInsets(top: -titleOffsetY, left: -titleOffsetX, bottom: titleOffsetY, right: titleOffsetX)
//        }
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
