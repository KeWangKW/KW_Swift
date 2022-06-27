//
//  KWPageCollectionViewListController.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/2.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit
import JXSegmentedView

class KWPageCollectionViewListController: KWCollectionRefreshViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func kw_configureData() {
        
    }
}

extension KWPageCollectionViewListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
