//
//  KWPageHeaderController.swift
//  Whatever
//
//  Created by 渴望 on 2020/7/7.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import JXPagingView
import JXSegmentedView

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

class KWPageHeaderController: KWViewController {

    lazy var pagingView: JXPagingView = preferredPagingView()
    lazy var userHeaderView: KWView = preferredTableHeaderView()
    var tableHeaderViewHeight: Int = 200
    var headerInSectionHeight: Int = 45

    let segmentedView = JXSegmentedView()

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

    override func kw_setupUI() {
        super.kw_setupUI()
        view.backgroundColor = .custom(.backgroundWhite)
        guard controllers.count > 0 else { return }

        navigationController?.interactivePopGestureRecognizer?.delegate = self

        segmentedDataSource = preferSegmentedDataSource()
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.indicators = segmentedIndicators
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        view.addSubview(segmentedView)


        let line = UIView()
        line.backgroundColor = .custom(.line)
        segmentedView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }

        pagingView.mainTableView.gestureDelegate = self
        self.view.addSubview(pagingView)

        segmentedView.listContainer = pagingView.listContainerView

        //扣边返回处理，下面的代码要加上
        pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }

    func preferredTableHeaderView() -> KWView {
        return KWView()
    }

    func preferredPagingView() -> JXPagingView {
        return JXPagingView(delegate: self)
    }

    /// 用于子类继承实现数据源
    /// - Returns: 数据源
    func preferSegmentedDataSource() -> JXSegmentedBaseDataSource {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titleSelectedColor = .Title
        dataSource.titleNormalColor = .Assist
        dataSource.titleNormalFont = .systemFont(ofSize: 14)
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 1.2
        dataSource.isTitleStrokeWidthEnabled = true
        dataSource.titles = titles
        return dataSource
    }

    /// 用于子类继承实现指示器
    /// - Returns: 指示器
    func preferSegmentedIndicators() -> [JXSegmentedIndicatorProtocol & UIView] {

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 22
        indicator.indicatorColor = .Base
        return [indicator]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension KWPageHeaderController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return tableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerInSectionHeight
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return controllers[index] as! JXPagingViewListViewDelegate
    }

}

extension KWPageHeaderController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension KWPageHeaderController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension KWPageHeaderController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止segmentedView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}

