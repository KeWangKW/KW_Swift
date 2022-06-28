//
//  UItableView+Radius.swift
//  KW_Swift
//
//  Created by Yinjoy on 2021/4/22.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit


extension UITableView {
    /*
    func registerXIBClass(xib: AnyClass) {
        let xibStr = NSStringFromClass(xib)
        let nibNameArr = xibStr.components(separatedBy: ".")
        self.register(UINib.init(nibName: nibNameArr.last!, bundle: Bundle.main), forCellReuseIdentifier: xibStr)
    }
    
    func tableviewShowNothingData(subtext: String, imageName: String, rowCount: Int) {
        
        if rowCount != 0 {
            self.backgroundView = nil
        }else{
            var backView = UIView.init()
            self.backgroundView = backView
            backView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            let imageView = UIImageView.init(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            backView = imageView
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(66)
                make.left.equalTo(66)
                make.right.equalTo(-66)
                make.height.equalTo(200)
            }
            
            let textLabel = UILabel.init()
            textLabel.text = subtext
            textLabel.font = .systemFont(ofSize: 14)
            textLabel.textColor = UIColor(hexString: "#434343")
            backView.addSubview(textLabel)
            textLabel.snp.makeConstraints { (make) in
                make.top.equalTo(imageView.snp.bottom).offset(10)
                make.centerX.equalTo(backView.snp.centerX)
            }
        }
        
    }
    */
}

extension UITableViewCell {
    /*
     不好用，待处理
     */
    
    ///给UITableView的Section切圆角 在willDisplaycell方法里面调用
    @objc func tableViewCornerRadius(tableView:UITableView, cellCornerRadius cornerRadius: CGFloat, forRowAt indexPath: IndexPath) {
        //圆率
        let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
        // 每一段的行数
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        //绘制曲线
        var bezierPath: UIBezierPath?
        if numberOfRows == 1 {
            bezierPath = lgl_bezierRoundedPath(.allCorners, cornerRadii)
        } else {
            switch indexPath.row {
                case 0: //第一个切左上右上
                    bezierPath = lgl_bezierRoundedPath([.topLeft, .topRight], cornerRadii)
                case numberOfRows-1: //最后一个切左下右下
                    bezierPath = lgl_bezierRoundedPath([.bottomLeft, .bottomRight], cornerRadii)
                default:
                    bezierPath = lgl_bezierPath()
            }
        }
        lgl_cellAddLayer(bezierPath!)
    }
    
    ///切圆角
    private func lgl_bezierRoundedPath(_ corners:UIRectCorner, _ cornerRadii:CGSize) -> UIBezierPath {
        return UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
    }
    ///不切圆角
    private func lgl_bezierPath() -> UIBezierPath {
        return UIBezierPath.init(rect: self.bounds)
    }
    
    ///添加到cell上
    private func lgl_cellAddLayer(_ bezierPath:UIBezierPath)  {
        self.backgroundColor = .clear
         //新建一个图层
        let layer = CAShapeLayer()
        //图层边框路径
        layer.path = bezierPath.cgPath
        
        //图层填充色,也就是cell的底色
        layer.fillColor = UIColor.red.cgColor
        
//        layer.fillColor = UIColor.white.cgColor
      layer.strokeColor = UIColor.red.cgColor
        
        self.layer.insertSublayer(layer, at: 0)
    }
}



extension UICollectionView {
    /*
    func registerXIBClass(xib: AnyClass) {
        let xibStr = NSStringFromClass(xib)
        let nibNameArr = xibStr.components(separatedBy: ".")
        self.register(UINib.init(nibName: nibNameArr.last!, bundle: Bundle.main), forCellWithReuseIdentifier: xibStr)
    }
     */
}
