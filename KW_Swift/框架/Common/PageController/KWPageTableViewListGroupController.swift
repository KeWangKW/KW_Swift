//
//  KWPageTableViewListGroupController.swift
//  KW_Swift
//
//  Created by 渴望 on 2021/3/17.
//  Copyright © 2021 guan. All rights reserved.
//

import UIKit
import JXSegmentedView

class KWPageTableViewListGroupController: KWRefreshGroupViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension KWPageTableViewListGroupController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
