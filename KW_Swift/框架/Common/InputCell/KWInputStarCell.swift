//
//  KWInputStarCell.swift
//  KW_Swift
//
//  Created by 渴望 on 2020/12/8.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

extension KWInputStarCellItem {
    
    /// 展示风格
    enum Style {
        case topDown  /**<上标题，下输入框*/
        case leftRight  /**<左   标题，右输入框*/
        case full  /**<无标题，纯输入框*/
        
        var height: CGFloat {
            switch self {
            case .topDown:
                return 85
            case .leftRight:
                return 45
            case .full:
                return 70
            }
        }
        
        var titleFont: UIFont {
            switch self {
            case .topDown:
                return .boldSystemFont(ofSize: 16)~
            case .leftRight, .full:
                return .systemFont(ofSize: 14)~
            }
        }
    }
    
    /// 输入框类型
    enum Mode {
        case normal  /**<默认*/
        case select  /**<选择项*/
        case code  /**<验证码*/
        case custom(view: UIView, cellHeight: CGFloat?)
    }
}

class KWInputStarCellItem: KWTableViewCellItem {
    override var cellHeight: CGFloat {
        get {
            guard case .custom(_, let height) = mode, height != nil else { return style.height }
            return height!
        }
        set { }
    }
    
    var hideStar:Bool = false
    /// 输入内容
    var text: String = ""
    
    /// 内容的颜色
    var textColor: UIColor? = .Title
    
    /// 占位内容
    var placeholder: String? = ""
    
    /// 键盘类型
    var keyboardType: UIKeyboardType = .default
    
    /// 限制长度
    var limitLength: Int?
    
    /// 限制字符
//    var limitCharacters: String?
    
    /// 输入是金额
    var isMoney: Bool = false
    
    /// 安全输入
    var isSecureTextEntry: Bool = false
    
    /// 禁止输入
    var isDisableInput: Bool = false
    
    /// 开始倒计时
    var isStartCountdown: Bool = false
    var selectImg:UIImage = UIImage(named: "kw_down_r")!
    var textAlignment:NSTextAlignment = .left //对齐方式
    
    var style: Style = .topDown
    var mode: Mode = .normal
    
    var becomeFirstResponder:Bool = false
    
    convenience init(_ style: Style, _ mode: Mode) {
        self.init()
        self.style = style
        self.mode = mode
    }
}

class KWInputStarCell: KWTableViewCell {
    
    override var item: KWTableViewCellItem! {
        didSet {
            cellItem = (item as! KWInputStarCellItem)
            
            if case let .custom(view, _) = cellItem!.mode {
                customView = view
                addSubview(view)
            } else {
                if let custom = customView, subviews.contains(custom) {
                    custom.removeFromSuperview()
                }
            }
            separatorLabel.isHidden = item.isShowBtmLine
            
            codeButton.isHidden = true
            codeLine.isHidden = true
            selectImageView.isHidden = true
            if case KWInputStarCellItem.Mode.code = cellItem!.mode {
                codeButton.isHidden = false
                codeLine.isHidden = false
            } else if case KWInputStarCellItem.Mode.select = cellItem!.mode {
                selectImageView.isHidden = false
                selectImageView.image = cellItem?.selectImg
            }
            textField.textAlignment = cellItem!.textAlignment
            titleLabel.font = cellItem!.style.titleFont
            titleLabel.isHidden = cellItem!.style == .full
            
            titleLabel.text = cellItem!.title
            titleLabel.textColor = cellItem?.titleColor
            textField.placeholder = cellItem!.placeholder
            textField.text = cellItem!.text
            textField.textColor = cellItem!.textColor
            textField.tintColor = cellItem!.textColor
            textField.isSecureTextEntry = cellItem!.isSecureTextEntry
            textField.keyboardType = cellItem!.keyboardType
            if cellItem!.isMoney {
                textField.keyboardType = .decimalPad
            }
            
            if cellItem!.isStartCountdown {
                startCountdown()
                textField.becomeFirstResponder()
                cellItem!.isStartCountdown.toggle()
            }
            
            if cellItem?.hideStar == true {
                starLab.isHidden = true
            }else{
                starLab.isHidden = false
            }
            
            
            if cellItem?.becomeFirstResponder == true {
                textField.clearButtonMode = .always
            }
            
            kw_setupLayouts()
        }
    }
    
    private var cellItem: KWInputStarCellItem?
    
    private var customView: UIView?
    
    /// 倒计时时间
    private var time: TimeInterval = totalTime
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Title
        label.font = .systemFont(ofSize: 16)
        label.text = "标题标题"
        return label
    }()
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.placeholder = ""
        view.delegate = self
        view.font = .systemFont(ofSize: 14)~
        view.clearButtonMode = .whileEditing
        view.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        return view
    }()
    
    private lazy var selectImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "kw_down_r"))
        imageView.contentMode = .center
        imageView.kw.tapAtion { [unowned self] (tap)  in
            self.delegate?.kw_responseViewInCell?(self, object: KWInputStarCellItem.Mode.select)
        }
        return imageView
    }()
    
    private lazy var codeLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Base
        return view
    }()
    
    private lazy var codeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("获取验证码", for: .normal)
        button.setTitleColor(.Base, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)~
        button.addTarget(self, action: #selector(codeButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var starLab:UILabel = {
        let lab = UILabel()
        lab.text = "*"
        lab.font = .systemFont(ofSize: 16)
        lab.textColor = .Orange
        return lab
    }()
    
    override func kw_setupViews() {
        super.kw_setupViews()
        
        selectionStyle = .none
        addSubview(starLab)
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(selectImageView)
        addSubview(codeButton)
        addSubview(codeLine)
    }
    
    override func kw_setupLayouts() {
        super.kw_setupLayouts()
        
        guard let item = cellItem else { return }
        
        let style = item.style
        
        switch style {
        case .topDown:
            makeTopDownConstraints()
        case .leftRight:
            makeLeftRightConstraints()
        case .full:
            makeFullConstraints()
        }
        
        if case let .custom(view, _) = cellItem!.mode {
            view.snp.remakeConstraints({ (make) in
                make.leading.bottom.equalTo(textField)
                make.trailing.equalTo(-CellPadding)
                if view.kw.height > 0 {
                    make.height.equalTo(view.kw.height)
                } else {
                    make.height.equalTo(textField)
                }
            })
        }
        
        
        selectImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-CellPadding+10)
            make.bottom.top.equalTo(textField)
            make.width.equalTo(selectImageView.snp.height)
        }
        codeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10~)
            make.bottom.height.equalTo(textField)
            make.width.equalTo(90~)
        }
        codeLine.snp.makeConstraints { (make) in
            make.trailing.equalTo(codeButton.snp.leading).offset(-10~)
            make.centerY.equalTo(codeButton)
            make.size.equalTo(CGSize(width: 1, height: 15~))
        }
    }
    
    @objc func codeButtonAction() {
        self.delegate?.kw_responseViewInCell?(self, object: KWInputStarCellItem.Mode.code)
    }
    
}

private let textFieldHeight: CGFloat = 40
extension KWInputStarCell {
    
    func makeTopDownConstraints() {
        titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(CellPadding)
            make.top.equalTo(17)
            make.trailing.lessThanOrEqualTo(-CellPadding)
        }
        textField.snp.remakeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(textFieldHeight)
            
            switch cellItem!.mode {
            case .code:
                make.trailing.equalTo(codeLine.snp.leading)
            case .select:
                make.trailing.equalTo(selectImageView.snp.leading)
            default:
                make.trailing.equalTo(-CellPadding)
            }
        }
    }
    
    func makeLeftRightConstraints() {
        titleLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(CellPadding + 7)
            make.centerY.equalTo(textField)
            make.trailing.equalTo(textField.snp.leading).offset(-5)
        }
        starLab.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel.snp.left).offset(0)
            make.centerY.equalTo(titleLabel.snp.centerY).offset(-1)
        }
        textField.snp.remakeConstraints { (make) in
            make.leading.equalTo(125~)
            make.bottom.equalToSuperview()
            make.height.equalTo(textFieldHeight)
            
            switch cellItem!.mode {
            case .normal:
                make.trailing.equalTo(-CellPadding)
            case .code:
                make.trailing.equalTo(codeLine.snp.leading)
            case .select:
                make.trailing.equalTo(selectImageView.snp.leading)
            default:
                break
            }
        }
    }
    
    func makeFullConstraints() {
        textField.snp.remakeConstraints { (make) in
            make.leading.equalTo(CellPadding)
            make.bottom.equalToSuperview()
            make.height.equalTo(textFieldHeight)
            
            switch cellItem!.mode {
            case .normal:
                make.trailing.equalTo(-CellPadding)
            case .code:
                make.trailing.equalTo(codeLine.snp.leading)
            case .select:
                make.trailing.equalTo(selectImageView.snp.leading)
            default:
                break
            }
        }
    }
}

private let totalTime: TimeInterval = 60
extension KWInputStarCell {
    
    /// 开始倒计时
    func startCountdown() {
        guard case KWInputStarCellItem.Mode.code = cellItem!.mode else { return }
        
        codeButton.isEnabled = false
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(deadline: DispatchTime.now(), repeating: .seconds(1))
        timer.setEventHandler {
            if self.time <= 1 {
                timer.cancel()
                DispatchQueue.main.async {
                    self.codeButton.setTitle("重新获取", for: .normal)
                    self.codeButton.isEnabled = true
                    self.time = totalTime
                }
                return
            }
            self.time -= 1
            DispatchQueue.main.sync {
                self.codeButton.setTitle("剩余\(Int(self.time))秒", for: .normal)
            }
        }
        timer.resume()
    }
}


extension KWInputStarCell: UITextFieldDelegate {
    
    @objc func textFieldDidChanged(_ textFiled: UITextField) {
        cellItem?.text = textFiled.text ?? ""
        
        cellItem?.BtnBlock?((cellItem?.text ?? "") as String)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if case KWInputStarCellItem.Mode.select = cellItem!.mode {
            self.delegate?.kw_responseViewInCell?(self, object: KWInputStarCellItem.Mode.select)
            return false
        }
        if cellItem!.isDisableInput {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if cellItem?.title == "手机号" {
            let fullStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if fullStr.count > 11 {
                return false
            }
        }
        
        var flag = true
        if cellItem!.isMoney {
            flag = textField.kw.isMoneyFomat(range: range, string: string)
            guard flag == true else { return flag }
        }
        if let length = cellItem?.limitLength {
            flag = textField.kw.limit(length: length, range: range, string: string)
            guard flag == true else { return flag }
        }
        return flag
    }
    
}

