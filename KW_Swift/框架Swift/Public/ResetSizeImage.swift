//
//  ResetSizeImage.swift
//  KW_Swift
//
//  Created by Yinjoy on 2021/5/20.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit

public extension UIImage {

    /// 压缩图片的大小，并且返回压缩后的Data
    class func resetSizeOfImageData(sourceImage: UIImage, maxSize: Int) -> Data? {
        
        if let finallImageData = sourceImage.jpegData(compressionQuality: 1.0) {
            return resetSizeOfImageData(sourceData: finallImageData, maxSize: maxSize)
        }
        return nil
        
    }

    class func resetSizeOfImageData(sourceData: Data, maxSize: Int) -> Data? {
        
        //先判断当前质量是否满足要求，不满足再进行压缩
        guard let sourceImage = UIImage(data: sourceData) else {
            return nil
        }
        var finallImageData = sourceData
        let sizeOrigin      = finallImageData.count
        let sizeOriginKB    = sizeOrigin / 1024
        if sizeOriginKB <= maxSize {
            return finallImageData
        }

        //获取原图片宽高比
        let sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height
        //先调整分辨率
        var defaultSize = CGSize(width: 1024, height: 1024/sourceImageAspectRatio)
        guard let newImage = self.newSizeImage(size: defaultSize, sourceImage: sourceImage) else {
            return nil
        }
        
        guard let newImageData  = newImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        finallImageData = newImageData
        //保存压缩系数
        var compressionQualityArr: [CGFloat] = []
        let avg = CGFloat(1.0/250)
        var value = avg
        
        var i = 250
        repeat {
            i -= 1
            value = CGFloat(i)*avg
            compressionQualityArr.append(value)
        } while i >= 1
        
        /*
         调整大小
         说明：压缩系数数组compressionQualityArr是从大到小存储。
         */
        //思路：使用二分法搜索
        
        guard let halfData = self.halfFuntion(arr: compressionQualityArr, image: newImage, sourceData: finallImageData, maxSize: maxSize) else {
            return nil
        }
        finallImageData = halfData
        
        //如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData.count == 0 {
            //每次降100分辨率
            let reduceWidth = 100.0
            let reduceHeight = 100.0/sourceImageAspectRatio
            if (defaultSize.width-CGFloat(reduceWidth)) <= 0 || (defaultSize.height-CGFloat(reduceHeight)) <= 0 {
                break
            }
            defaultSize = CGSize(width: (defaultSize.width-CGFloat(reduceWidth)), height: (defaultSize.height-CGFloat(reduceHeight)))
            
            guard let lastCompressionData = newImage.jpegData(compressionQuality: compressionQualityArr.last ?? 1) else {
                return nil
            }
            guard let lastCompressionImage = UIImage.init(data: lastCompressionData) else {
                return nil
            }
            guard let image = self.newSizeImage(size: defaultSize, sourceImage: lastCompressionImage) else {
                return nil
            }
            
            guard let sourceData = image.jpegData(compressionQuality: 1.0),
                let halfData = halfFuntion(arr: compressionQualityArr, image: image, sourceData: sourceData, maxSize: maxSize) else {
                    return nil
            }
            finallImageData = halfData
        }
        
        return finallImageData
    }
    
    // MARK: - 调整图片分辨率/尺寸（等比例缩放）
    class func newSizeImage(size: CGSize, sourceImage: UIImage) -> UIImage? {
        var newSize = CGSize(width: sourceImage.size.width, height: sourceImage.size.height)
        let tempHeight = newSize.height / size.height
        let tempWidth = newSize.width / size.width
        
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
        } else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: - 二分法
    class func halfFuntion(arr: [CGFloat], image: UIImage, sourceData finallImageData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = finallImageData
        
        var tempData = Data.init()
        var start = 0
        var end = arr.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start)/2
            
            guard let imageJpegData = image.jpegData(compressionQuality: arr[index]) else {
                return nil
            }
            tempFinallImageData = imageJpegData
            
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            
            print("当前降到的质量：\(sizeOriginKB)\n\(index)----\(arr[index])")
            
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize-sizeOriginKB < difference {
                    difference = maxSize-sizeOriginKB
                    tempData = tempFinallImageData
                }
                if index<=0 {
                    break
                }
                end = index - 1
            } else {
                break
            }
        }
        return tempData
    }
}
