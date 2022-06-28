//
//  UIImageViewExt.swift
//  Whatever
//
//  Created by 渴望 on 2020/7/17.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import Kingfisher

public extension KWSwiftWrapper where Base: UIImageView {
    
    func scaleAspectFill() {
        base.contentMode = .scaleAspectFill
        base.clipsToBounds = true
    }
    
}

extension UIImageView {
    func setImage(with string: String?, placeholder image: UIImage? = UIImage(color: .gray)) {
        guard var string = string else { return }
        if !string.hasPrefix(Api.base) {
            string = Api.base + string
        }
        self.kf.setImage(with: URL(string: string), placeholder: image)
    }
}
