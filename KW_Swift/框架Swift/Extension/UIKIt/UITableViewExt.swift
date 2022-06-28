//
//  UITableViewExt.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/27.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

public extension KWSwiftWrapper where Base: UITableView {
    func register(cell: AnyClass) {
        base.register(cell, forCellReuseIdentifier: NSStringFromClass(cell))
    }
    func registerXib(cellXib: AnyClass) {
        let cellXibStr = NSStringFromClass(cellXib)
        let nibNameArr = cellXibStr.components(separatedBy: ".")
        base.register(UINib.init(nibName: nibNameArr.last!, bundle: Bundle.main), forCellReuseIdentifier: NSStringFromClass(cellXib))
    }
    
    func register(cells: AnyClass...) {
        cells.forEach { register(cell: $0) }
    }
    
    func register(view: AnyClass) {
        base.register(view, forHeaderFooterViewReuseIdentifier: NSStringFromClass(view))
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        return base.dequeueReusableCell(withIdentifier: NSStringFromClass(cell), for: indexPath) as! T
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(view: T.Type) -> T {
        return base.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(view)) as! T
    }
}
