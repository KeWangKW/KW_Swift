//
//  KWCollectionViewCell.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/2.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

class KWCollectionViewCellItem: NSObject, KWCellItemProtocol {
    
    typealias T = UICollectionViewCell
    final public var cellIdentifier: String {
        let item = "Item"
        let clsName = NSStringFromClass(type(of: self))
        guard clsName.hasSuffix(item) else { return clsName }
        return String(clsName.prefix(clsName.count - item.count))
    }
    
    public var cellClass: T.Type {
        return NSClassFromString(self.cellIdentifier) as! T.Type
    }
    
    public var title: String?
    
    public var imageName: String?
    
    var selector: Selector?
    
    public var cellModel: KWModel?
    
    required public init(model: KWModel?) {
        self.cellModel = model
    }
    
    override init() {
    }
    
    public var cellSize: CGSize = .zero
    
}

// MARK: - KWCollectionViewCell
class KWCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: KWCollectionViewCellDelegate?
    
    var item: KWCollectionViewCellItem! {
        didSet {}
    }
    
    var separatorInset: UIEdgeInsets = .zero
    
    
    lazy var separatorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .custom(.section)
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        kw_setupViews()
        kw_setupLayouts()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        kw_setupViews()
        kw_setupLayouts()
    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func kw_setupViews() {
        backgroundColor = .custom(.backgroundWhite)
        
        addSubview(separatorLabel)
        bringSubviewToFront(separatorLabel)
    }
    
    func kw_setupLayouts() {
        separatorLabel.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.separatorInset)
            make.height.equalTo(0.5)
        }
    }
}


