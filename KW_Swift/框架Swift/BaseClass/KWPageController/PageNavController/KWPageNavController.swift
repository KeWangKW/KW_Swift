//
//  KWPageController.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/1.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import JXSegmentedView

class KWPageNavController: KWViewController {

    let segmentedView = JXSegmentedView()
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    /// 数据源
    var segmentedDataSource: JXSegmentedBaseDataSource?
    
    /// 指示器
    var segmentedIndicators: [JXSegmentedIndicatorProtocol & UIView] {
        return preferSegmentedIndicators()
    }
    
    var titles = [String]()
    var controllers = [KWViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nav_color_clear()
        self.fd_prefersNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    

    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        view.backgroundColor = .custom(.backgroundWhite)
        guard controllers.count > 0 else { return }
        
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        segmentedDataSource = preferSegmentedDataSource()
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.indicators = segmentedIndicators
        
        navView.addSubview(segmentedView)
        
        segmentedView.listContainer = listContainerView
        navView.addSubview(listContainerView)
        
        segmentedView.snp.makeConstraints { (make) in
            make.top.equalTo(KStatusBarHeight)
            make.left.equalTo(75)
            make.right.equalTo(-75)
            make.height.equalTo(42)
        }
        listContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
        
        //关闭页面左右滑动，兼容cell左滑
        listContainerView.scrollView.isScrollEnabled = false
        
//        self.navigationItem.titleView = navView
        view.addSubview(navView)
    }
    
    
    /// 用于子类继承实现数据源
    /// - Returns: 数据源
    func preferSegmentedDataSource() -> JXSegmentedBaseDataSource {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titleSelectedColor = .black
        dataSource.titleNormalColor = .black
        dataSource.titleNormalFont = .systemFont(ofSize: 18)
        
        dataSource.itemContentWidth = 0
        dataSource.itemWidthIncrement = (KScreenWidth-150)/CGFloat(titles.count)
        //KScreenWidth/2
        dataSource.itemSpacing = 0
//        dataSource.isItemSpacingAverageEnabled = false
        
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 1
        dataSource.isTitleStrokeWidthEnabled = true
        dataSource.isItemSpacingAverageEnabled = true
//        dataSource.isItemWidthZoomEnabled = true
        dataSource.titles = titles
        return dataSource
    }
    
    /// 用于子类继承实现指示器
    /// - Returns: 指示器
    func preferSegmentedIndicators() -> [JXSegmentedIndicatorProtocol & UIView] {
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 63 //KScreenWidth/CGFloat(titles.count)
        indicator.indicatorColor = UIColor.init(hexString: "EDAE54")
        indicator.indicatorHeight = 4
        return [indicator]
    }

    private lazy var navView:UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
        return v
    }()
    
}


// MARK: - JXSegmentedListContainerViewDataSource
extension KWPageNavController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        guard let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource else { return 0 }
        return titleDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return controllers[index] as! JXSegmentedListContainerViewListDelegate
    }
    
}

// MARK: - JXSegmentedViewDelegate
extension KWPageNavController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    @objc func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension KWPageNavController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


