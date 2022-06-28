//
//  EmptyDataSet.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/21.
//  Copyright © 2020 渴望. All rights reserved.
//

#if canImport(DZNEmptyDataSet)
import DZNEmptyDataSet


private var EmptyDataSetTitleKey: Void?
private var EmptyDataSetDescriptionKey: Void?
private var EmptyDataSetImageKey: Void?

public extension KWSwiftWrapper where Base: KWViewController {
    
    var emptyDataSetTitle: String {
//        get { return objc_getAssociatedObject(base, &EmptyDataSetTitleKey) as? String ?? "暂无数据" }
        get { return objc_getAssociatedObject(base, &EmptyDataSetTitleKey) as? String ?? " " }
         set { objc_setAssociatedObject(base, &EmptyDataSetTitleKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    var emptyDataSetDescription: String {
        get { return objc_getAssociatedObject(base, &EmptyDataSetDescriptionKey) as? String ?? "" }
        set { objc_setAssociatedObject(base, &EmptyDataSetDescriptionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    var emptyDataSetImage: UIImage? {
//        get { return objc_getAssociatedObject(base, &EmptyDataSetImageKey) as? UIImage ?? UIImage(named: "ic_zeroshuj") }
        get { return objc_getAssociatedObject(base, &EmptyDataSetImageKey) as? UIImage ?? UIImage() }
        set { objc_setAssociatedObject(base, &EmptyDataSetImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension KWViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    // MARK: - DataSource
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.custom(.assist)
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 16)
        return NSAttributedString(string: kw.emptyDataSetTitle, attributes: attributes)
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.custom(.assist)
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 12)
        return NSAttributedString(string: kw.emptyDataSetDescription, attributes: attributes)
    }
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return kw.emptyDataSetImage!
    }
    
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .clear
    }
    
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -100
    }
    
    // MARK: - Delegate
    public func emptyDataSetWillAppear(_ scrollView: UIScrollView!) {
        scrollView.contentOffset = .zero
    }
    
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}



#endif
