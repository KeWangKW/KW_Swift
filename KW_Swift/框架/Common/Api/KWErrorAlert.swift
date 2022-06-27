//
//  KWErrorAlert.swift
//  KW_Swift
//
//  Created by 渴望 on 2022/1/22.
//  Copyright © 2022 guan. All rights reserved.
//

import UIKit

class KWErrorAlert: KWView {

    lazy var view:UIView = {
        return Bundle.main.loadNibNamed("KWErrorAlert", owner: self, options: nil)?.first as! UIView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: (KScreenWidth-245)/2, y: KStatusBarHeight+25, width: 245, height: 135))
        view.frame = bounds
        addSubview(view)
        
        self.backgroundColor = .clear
        view.backgroundColor = .clear
        labBGView.backgroundColor = UIColor(sHex: "ffffff", alpha: 1)
        labBGView.layer.masksToBounds = true
        labBGView.layer.cornerRadius = 45/2
        labBGView.layer.borderWidth = 1
        labBGView.layer.borderColor = UIColor.Section.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    @IBOutlet weak var labBGView: UIView!
    @IBOutlet weak var msgLab: UILabel!
    
    func setMsg(str:String) {
        msgLab.text = str
        
        self.startCountdown()
    }
    
    
    private var time: TimeInterval = 3 /// 倒计时时间
    //MARK: 开始倒计时
    func startCountdown() {
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(deadline: DispatchTime.now(), repeating: .seconds(1))
        timer.setEventHandler {
            if self.time <= 1 {
                timer.cancel()
                DispatchQueue.main.async {
                    
                    self.removeFromSuperview()
                }
                return
            }
            self.time -= 1
        }
        timer.resume()
    }
    
    
}
