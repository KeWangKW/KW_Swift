//
//  UIImage+Kingfisher.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/28.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import Kingfisher


extension UIImageView {
    func setImage(with string: String?, placeholder image: UIImage? = UIImage(color: .gray)) {
        guard var string = string else { return }
        if !string.hasPrefix(Api.base) {
            string = Api.base + string
        }
        self.kf.setImage(with: URL(string: string), placeholder: image)
    }
}
