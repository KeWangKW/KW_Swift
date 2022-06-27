//
//  KWTableViewCell.swift
//  BaseSwift
//
//  Created by 渴望 on 2019/6/6.
//  Copyright © 2019 渴望. All rights reserved.
//

import UIKit
//import ObjectMapper

typealias  BlockCellBtnClick = (Any) ->() //1.声明闭包

// MARK: - KWTableViewCellItem
class KWTableViewCellItem: NSObject, KWCellItemProtocol {
    var BtnBlock : BlockCellBtnClick? //2.闭包声明称属性
    func btnClick(jumpbtnClickBlock:@escaping BlockCellBtnClick) -> Void { //3.实现方法
        BtnBlock = jumpbtnClickBlock;
    }
    
    typealias T = UITableViewCell
    final public var cellIdentifier: String {
        let item = "Item"
        let clsName = NSStringFromClass(type(of: self))
        guard clsName.hasSuffix(item) else { return clsName }
        return String(clsName.prefix(clsName.count - item.count))
    }
    
    final public var cellClass: T.Type {
        return NSClassFromString(self.cellIdentifier) as! T.Type
    }
    
    public var title: String?
    public var titleColor: UIColor = .Title
    
    public var imageName: String?
    
    public var selector: Selector?
    
    public var cellModel: KWModel?
    
    required public init(model: KWModel?) {
        self.cellModel = model
    }
    
    override init() {}
    
    
    public var cellHeight: CGFloat = 0
    
    public var isShowIndicator: Bool = false
    
    public var isShowBtmLine: Bool = true
    
    public var index_section:Int = 0
    public var index_row:Int = 0
}


// MARK: - KWTableViewCell
class KWTableViewCell: UITableViewCell {
    
    weak var delegate: KWTableViewCellDelegate?
    
    var item: KWTableViewCellItem! {
        didSet {
            guard let item = item else { return }
            guard item.isMember(of: KWTableViewCellItem.self) else { return }
            
            self.textLabel?.text = item.title
            self.textLabel?.textColor = item.titleColor
            separatorLabel.isHidden = item.isShowBtmLine
            if let imageName = item.imageName {
                self.imageView?.image = UIImage(named: imageName)
            } else {
                self.imageView?.image = nil
            }
            
            if item.selector != nil {
                self.addGestureRecognizer(self.tapRecognizer)
            } else {
                self.removeGestureRecognizer(self.tapRecognizer)
            }
            
            if accessoryType == .none, accessoryView == nil {
                accessoryType = item.isShowIndicator ? .disclosureIndicator : .none
            }
            
            self.selectionStyle = .none
        }
    }
    
    lazy var separatorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .custom(.line)
        return label
    }()
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        return tap
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        kw_setupViews()
        kw_setupLayouts()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        kw_setupViews()
        kw_setupLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    public func kw_setupViews() -> Void {
        layoutMargins = .zero
        separatorInset = UIEdgeInsets(top: 0, left: CellPadding, bottom: 0, right: CellPadding)
        backgroundColor = .custom(.backgroundWhite)
        textLabel?.textColor = .custom(.title)
        textLabel?.font = .systemFont(ofSize: 15)
        
        addSubview(separatorLabel)
    }
    
    public func kw_setupLayouts() {
        separatorLabel.snp.makeConstraints { (make) in
            //make.leading.trailing.bottom.equalTo(self.separatorInset)
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        bringSubviewToFront(separatorLabel)
    }
    
    @objc private func tapGestureAction() {
        guard
            let selector = item.selector,
            let controller = kw.currentController,
            controller.responds(to: selector)
        else { return }
        controller.perform(selector)
    }
}



extension Array where Element == [KWTableViewCellItem] {
    func item(for title: String) -> KWTableViewCellItem? {
        for items in self {
            if let item = items.item(for: title) {
                return item
            }
        }
        return nil
    }
}

extension Array where Element == KWTableViewCellItem {
    func item(for title: String) -> KWTableViewCellItem? {
        for item in self {
            if item.title == title {
                return item
            }
        }
        return nil
    }
}
