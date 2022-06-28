//
//  KWCollectionViewController.swift
//  Whatever
//
//  Created by 渴望 on 2020/6/1.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

class KWCollectionViewController: KWViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func kw_setupData() {
        super.kw_setupData()
        
    }
    
    override func kw_setupUI() {
        super.kw_setupUI()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
    // MARK: - ConfigureData 初始化数据
    public func kw_configureData() {}
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .zero
        layout.sectionHeadersPinToVisibleBounds = true
        
        let collect = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collect.delegate = self
        collect.dataSource = self
        collect.emptyDataSetSource = self
        collect.emptyDataSetDelegate = self
        collect.backgroundColor = .custom(.section)
        if #available(iOS 11.0, *) {
            collect.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        collect.kw.register(cell: KWCollectionViewCell.self)
        collect.kw.register(header: UICollectionReusableView.self)
        collect.kw.register(footer: UICollectionReusableView.self)
        return collect
    }()
    
    lazy var dataArr: [[KWCollectionViewCellItem]] = {
        let datas = [[KWCollectionViewCellItem]]()
        return datas
    }()
    
    lazy var section0Arr: [KWCollectionViewCellItem] = {
        let section = [KWCollectionViewCellItem]()
        return section
    }()
    
    lazy var section1Arr: [KWCollectionViewCellItem] = {
        let section = [KWCollectionViewCellItem]()
        return section
    }()
    
    lazy var section2Arr: [KWCollectionViewCellItem] = {
        let section = [KWCollectionViewCellItem]()
        return section
    }()
    
    lazy var section3Arr: [KWCollectionViewCellItem] = {
        let section = [KWCollectionViewCellItem]()
        return section
    }()
    
    lazy var section4Arr: [KWCollectionViewCellItem] = {
        let section = [KWCollectionViewCellItem]()
        return section
    }()
}


extension KWCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataArr[indexPath.section][indexPath.row]
        let cell = collectionView.kw.dequeue(cell: item.cellClass, for: indexPath) as! KWCollectionViewCell
        cell.item = item
        cell.delegate = self
        
        
        return cell
    }
}

extension KWCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout, layout.itemSize != .zero {
            return layout.itemSize
        }
        
        if indexPath.section == dataArr.count {
            return .zero
        }
        
        let item = dataArr[indexPath.section][indexPath.row]
        return item.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
        view.backgroundColor = .custom(.section)
        return view
    }
}

extension KWCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}


extension KWCollectionViewController: KWCollectionViewCellDelegate {
}
