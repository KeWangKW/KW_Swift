//
//  CustomSlider.swift
//  KW_Swift
//
//  Created by Yinjoy on 2021/4/20.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    init() {
        super.init(frame: CGRect())
        self.minimumValue = 0
        self.maximumValue = 100
        self.value = 0
        self.minimumTrackTintColor = UIColor(hexString: "#F3D8AA")
        self.maximumTrackTintColor = UIColor(hexString: "#E5E5E5")
        //自定义圆点图标
        self.setThumbImage(UIImage(named: "slider_icon"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //修改slider的位置和大小
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: self.frame.size.width, height: 26)
    }
    //修改圆点图标的位置和触摸区域的大小
//    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
//        var trect = rect
//        trect.origin.x -= 5
//        trect.size.width += 10
//        var srect = super.thumbRect(forBounds: bounds, trackRect: trect, value: value)
//        srect.origin.y += 2
//        return srect
//    }
    //处理手势冲突
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
