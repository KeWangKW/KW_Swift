//
//  KWPageController.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/1.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import JXSegmentedView

class KWPageController: KWViewController {

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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.fd_interactivePopDisabled = !(segmentedView.selectedIndex == 0)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        navigationController?.fd_interactivePopDisabled = false
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    

    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        view.backgroundColor = .custom(.backgroundWhite)
        guard controllers.count > 0 else { return }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        segmentedDataSource = preferSegmentedDataSource()
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.indicators = segmentedIndicators
        
        view.addSubview(segmentedView)
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        
        segmentedView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
//            make.top.equalToSuperview()
//            make.left.equalTo(-75~)
//            make.right.equalTo(65~)
            make.height.equalTo(42)
        }
        listContainerView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
    }
    
    
    /// 用于子类继承实现数据源
    /// - Returns: 数据源
    func preferSegmentedDataSource() -> JXSegmentedBaseDataSource {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titleSelectedColor = UIColor.init(hexString: "E7CB97")
        dataSource.titleNormalColor = .Content
        dataSource.titleNormalFont = .systemFont(ofSize: 14)
        
        dataSource.itemContentWidth = 0
        dataSource.itemWidthIncrement = KScreenWidth/CGFloat(titles.count) //KScreenWidth/2
        dataSource.itemSpacing = 0
        dataSource.isItemSpacingAverageEnabled = false
        
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 1
        dataSource.isTitleStrokeWidthEnabled = true
//        dataSource.isItemSpacingAverageEnabled = true
//        dataSource.isItemWidthZoomEnabled = true
        dataSource.titles = titles
        return dataSource
    }
    
    /// 用于子类继承实现指示器
    /// - Returns: 指示器
    func preferSegmentedIndicators() -> [JXSegmentedIndicatorProtocol & UIView] {
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = KScreenWidth/CGFloat(titles.count)
        indicator.indicatorColor = .Base
        indicator.indicatorHeight = 1.5
        return [indicator]
    }

}


// MARK: - JXSegmentedListContainerViewDataSource
extension KWPageController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        guard let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource else { return 0 }
        return titleDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return controllers[index] as! JXSegmentedListContainerViewListDelegate
    }
    
}

// MARK: - JXSegmentedViewDelegate
extension KWPageController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
//        navigationController?.fd_interactivePopDisabled = !(segmentedView.selectedIndex == 0)
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    @objc func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension KWPageController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

