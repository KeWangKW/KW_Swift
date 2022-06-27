//
//  UIImageExt.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/26.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

// MARK: - Properties
public extension KWSwiftWrapper where Base: UIImage {
    /// 内存大小 b
    var b: Int {
        return base.jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// 内存大小 k
    var kb: Int {
        return (base.jpegData(compressionQuality: 1)?.count ?? 0) / 1024
    }
    
    /// 使用原图
    var original: UIImage {
        return base.withRenderingMode(.alwaysOriginal)
    }
}

// MARK: - Methods
public extension KWSwiftWrapper where Base: UIImage {
    
    func tintColor(_ color: UIColor) -> UIImage {
        if #available(iOS 13.0, *) {
            return base.withTintColor(color)
        } else {
            //return base
//            let rect = CGRect.init(x: 0, y: 0, width: base.size.width, height: base.size.height)
//            UIGraphicsBeginImageContext(rect.size)
//            let context = UIGraphicsGetCurrentContext()
//            context?.setFillColor(color.cgColor)
//            context?.fill(rect)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return image!
            //UIImage().scale
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: base.size.width, height: base.size.height), false, 5)
            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: 0, y: base.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.setBlendMode(CGBlendMode.normal)
            let rect = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
            context?.clip(to: rect, mask: base.cgImage!)
            color.setFill()
            context?.fill(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
    }
    

    
    
    /// 压缩图片
    /// - Parameter quality: 压缩质量 默认0.5
    /// - Returns: 压缩后的图片
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = base.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }
    
    
    /// 压缩图片成base64字符串
    /// - Parameter quality: 压缩质量 默认0.5
    /// - Returns: 压缩后base64字符串
    func compressedBase64(quality: CGFloat = 0.5) -> String? {
        guard let data = base.jpegData(compressionQuality: quality) else { return nil }
        return data.base64EncodedString()
    }

    
    /// 压缩图片成data
    /// - Parameter quality: 压缩质量 默认0.5
    /// - Returns: 压缩后的data
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return base.jpegData(compressionQuality: quality)
    }

    
    /// 裁剪图片
    /// - Parameter rect: 裁剪的位置
    /// - Returns: 裁剪后的图片
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= base.size.width && rect.size.height <= base.size.height else { return base }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: base.scale, y: base.scale))
        guard let image = base.cgImage?.cropping(to: scaledRect) else { return base }
        return UIImage(cgImage: image, scale: base.scale, orientation: base.imageOrientation)
    }

    
    /// 通过改变高度来等比缩放图片
    /// - Parameters:
    ///   - toHeight: 修改的高度
    ///   - opaque: 是否透明 默认否
    /// - Returns: 缩放后的图片
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / base.size.height
        let newWidth = base.size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
    /// 通过改变宽度来等比缩放图片
    /// - Parameters:
    ///   - toHeight: 修改的宽度
    ///   - opaque: 是否透明 默认否
    /// - Returns: 缩放后的图片
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / base.size.width
        let newHeight = base.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 图片保存到本地
    /// - Parameter completion: 回调（yes or no）
    func saveLocally(_ completion: ((Bool) -> ())? = nil) {
        base.saveToLocation(completion)
    }
    
    // MARK: - 静态方法
    
    
}

// MARK: - Save Image To Location
private extension UIImage {
    
    typealias SaveCompletion = (Bool) -> ()
    
    struct AssociatedKeys {
        static var saveKey = "saveKey"
    }
    
    var completion: SaveCompletion? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.saveKey) as? SaveCompletion ?? nil}
        set { objc_setAssociatedObject(self, &AssociatedKeys.saveKey, newValue, .OBJC_ASSOCIATION_COPY)}
    }
    
    func saveToLocation(_ completion: SaveCompletion? = nil) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        completion?(didFinishSavingWithError == nil)
    }
}

// MARK: - QRCodeImage
public extension KWSwiftWrapper where Base: UIImage {
    
    static func generateQRImage(content: String?, icon: UIImage? = nil, size: CGFloat = 100) -> UIImage? {
        guard content != nil else { return nil }
        guard let ciImage = makeCIImage(content: content!) else { return nil }
        let qrImage =  makeHDQRImage(image: ciImage, size: size)
        guard icon != nil else { return qrImage }
        guard let newImage = composed(qrImage: qrImage, icon: icon!) else { return nil }
        return newImage
    }
    
    
    private static func makeCIImage(content: String) -> CIImage? {
        guard let data = content.data(using: .utf8) else { return nil }
        guard let imageFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        imageFilter.setDefaults()
        imageFilter.setValue(data, forKey: "inputMessage")
        imageFilter.setValue("H", forKey: "inputCorrectionLevel")
        guard let ciImage = imageFilter.outputImage else { return nil }
        return ciImage
    }
    
    
    private static func makeHDQRImage(image: CIImage, size: CGFloat) -> UIImage {
        let scaleSize = size * UIScreen.main.scale
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(scaleSize / integral.width, scaleSize / integral.height)
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    private static func composed(qrImage: UIImage, icon: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(qrImage.size)
        defer {
            UIGraphicsEndImageContext()
        }
        qrImage.draw(in: CGRect(origin: CGPoint.zero, size: qrImage.size))
        let iconWH = qrImage.size.width / 5
        let x = (qrImage.size.width - iconWH) * 0.5
        let y = (qrImage.size.height - iconWH) * 0.5
        icon.draw(in: CGRect(x: x, y: y, width: iconWH, height: iconWH))
        return UIGraphicsGetImageFromCurrentImageContext() ?? nil
    }
}


// MARK: - Convenience init
public extension UIImage {
    
    /// 通过颜色初始化
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 尺寸 默认{1, 1}
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        let rect: CGRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(size)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            self.init()
            return
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = newImage?.cgImage else {
            self.init()
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
    
    /// 通过base64字符串初始化
    /// - Parameter base64: base64字符串
    convenience init?(base64: String?) {
        guard let base64 = base64 else {
            self.init()
            return nil
        }
        guard let data = Data(base64Encoded: base64) else {
            self.init()
            return nil
        }
        self.init(data: data)
    }

}
