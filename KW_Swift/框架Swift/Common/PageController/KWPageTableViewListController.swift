//
//  KWPageTableViewListController.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/1.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import JXSegmentedView

class KWPageTableViewListController: KWRefreshViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension KWPageTableViewListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

