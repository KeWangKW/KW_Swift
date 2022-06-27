//
//  CAGradientLayer+Extesion.swift
//  KW_Swift
//
//  Created by Yinjoy on 2021/4/24.
//  Copyright © 2021 guan. All rights reserved.
//

import Foundation

extension CAGradientLayer {
    func GradientLayer(startColor : CGColor,endColor:CGColor,startPoint : CGPoint = CGPoint(x: 1, y: 0),endPoint : CGPoint = CGPoint(x: 0, y: 0) ) -> CAGradientLayer {
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        return gradientLayer
    }
}
