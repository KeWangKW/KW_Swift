//
//  KWPageHeaderCollectionViewListController.swift
//  Whatever
//
//  Created by 渴望 on 2020/7/8.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import JXPagingView

class KWPageHeaderCollectionViewListController: KWCollectionRefreshViewController {

    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           self.listViewDidScrollCallback?(scrollView)
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

extension KWPageHeaderCollectionViewListController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    func listScrollView() -> UIScrollView {
        return self.collectionView
    }

    func listWillAppear() {
        print("\(self.title ?? ""):\(#function)")
    }

    func listDidAppear() {
        print("\(self.title ?? ""):\(#function)")
    }

    func listWillDisappear() {
        print("\(self.title ?? ""):\(#function)")
    }

    func listDidDisappear() {
        print("\(self.title ?? ""):\(#function)")
    }
}
