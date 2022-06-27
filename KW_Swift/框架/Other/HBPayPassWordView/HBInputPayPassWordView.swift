//
//  HBInputPayPassWordView.swift
//  hivebox
//
//  Created by hivebox_tianjun on 2019/8/7.
//  Copyright © 2019 Ethan. All rights reserved.
//

import UIKit
extension UIColor {
    /// rgb(a)十进制
    public convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    /// rgb(a)0xffffff十六进制
    public convenience init(_ hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
    
    /// 参数：16进制字符串，不带前缀
    public convenience init(hexStr: String) {
        let hex = strtoul(hexStr, nil, 16)
        self.init(Int(hex))
    }
    
    /// 用自身颜色生成UIImage
    public var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
///支付密码输入文本框
class HBInputPayPassWordView: UIView {
    typealias InputPayPwdHandler = (_ payPassWord: String) -> Void
    var payPassWordHandler: InputPayPwdHandler?
    private var inputPwdLabelArray: [UILabel] = [UILabel]()
    ///支付密码长度位数默认为6位
    var inputPwdNumber: Int = 6 {
        didSet {
            setNeedsDisplay()
        }
    }
    ///输入密码字体颜色和大小
    var inputPwdColorOrFont: (UIColor, CGFloat) = (UIColor(0x4A4A4A), 14) {
        didSet {
            setNeedsDisplay()
        }
    }
    ///是否禁用键盘输入
    var isCanBeInputPwd: Bool = true
    ///默认密文显示
    var inputPwdIsClipherText: Bool = true
    //fileprivate
    lazy var inputPwdTextField: UITextField = {
        let pwdTextField = UITextField()
        pwdTextField.keyboardType = .numberPad
        pwdTextField.autocapitalizationType = .none
        pwdTextField.isHidden = true
        pwdTextField.addTarget(self, action: #selector(textDidChangeValue(_:)), for: .editingChanged)
        return pwdTextField
    }()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        setUpEvents()
        setUpData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        
        for subview in self.subviews {
            if subview.isKind(of: UIImageView.self) || subview.isKind(of: UILabel.self) {
                subview.removeFromSuperview()
            }
        }
        let pwdGridViewWidth = self.bounds.size.width / CGFloat(inputPwdNumber)
        for i in 0 ..< inputPwdNumber - 1 {
            let grayLineImageView = UIImageView()
            grayLineImageView.frame = CGRect(x: CGFloat(i + 1) * pwdGridViewWidth, y: 0, width: 1, height: self.bounds.size.height)
            grayLineImageView.backgroundColor = UIColor(0xdddddd)
            self.addSubview(grayLineImageView)
        }
        inputPwdLabelArray.removeAll()
        for i in 0 ..< inputPwdNumber {
            let pwdLabel = UILabel()
            pwdLabel.frame = CGRect(x: CGFloat(i) * CGFloat((pwdGridViewWidth)), y: 0, width: pwdGridViewWidth, height: self.bounds.size.height)
            pwdLabel.textColor = inputPwdColorOrFont.0
            pwdLabel.font = UIFont.systemFont(ofSize: inputPwdColorOrFont.1)
            pwdLabel.text = nil
            pwdLabel.textAlignment = .center
            pwdLabel.isUserInteractionEnabled = false
            self.addSubview(pwdLabel)
            inputPwdLabelArray.append(pwdLabel)
            
        }
    }
}
extension HBInputPayPassWordView {
    fileprivate func setUpViews() {
       self.addSubview(inputPwdTextField)
        
    }
    fileprivate func setUpConstraints() {
        inputPwdTextField.frame = .zero
    }
    fileprivate func setUpEvents() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyBoard(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    fileprivate func setUpData() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(0xdddddd).cgColor
    }
    @objc fileprivate func showKeyBoard(_ tapgesture: UITapGestureRecognizer) {
        inputPwdTextField.becomeFirstResponder()
    }
    ///变为第一焦点显示键盘
    func inputPwdTextFieldBecomeResponder() {
        inputPwdTextField.becomeFirstResponder()
        
    }
    ///清空输入文本框
    func clearInputPayPwdText() {
        for pwdLabel in inputPwdLabelArray {
            pwdLabel.text = nil
        }
        inputPwdTextField.text = nil
    }
    ///失去焦点隐藏键盘
    func inputPwdTextFieldResignFirstResponder() {
        inputPwdTextField.resignFirstResponder()
    }
    ///设置明文
    fileprivate func setClearText(_ inputPwdText: String) {
        for pwdLabel in inputPwdLabelArray {
            pwdLabel.text = nil
        }
        for (i, pwdStr) in inputPwdText.enumerated() {
            inputPwdLabelArray[i].text = "\(pwdStr)"
        }
    }
    ///设置密文用"●"替代显示
    fileprivate func setClipherText(_ dotNum: Int) {
        for pwdLabel in inputPwdLabelArray {
            pwdLabel.text = nil
        }
        for i in 0 ..< dotNum {
            inputPwdLabelArray[i].text = "●"
        }
    }
    ///文本编辑监听
    @objc fileprivate func textDidChangeValue(_ textField: UITextField) {
        if isCanBeInputPwd {
            let inputPwdText = textField.text ?? ""
            if inputPwdText.count > inputPwdNumber {
                textField.deleteBackward()
                return
            }
            ///密文
            if inputPwdIsClipherText {
                setClipherText(inputPwdText.count)
            } else {
                setClearText(inputPwdText)
            }
            payPassWordHandler?(inputPwdText)
        } else {
            #if DEBUG
            print("禁止键盘输入支付密码")
            #else
            #endif
            
        }
      
    }
}
