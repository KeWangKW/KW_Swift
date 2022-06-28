//
//  KWTextView.swift
//  BaseSwift
//
//  Created by 渴望 on 2020/5/27.
//  Copyright © 2020 渴望. All rights reserved.
//

import UIKit

class KWTextView: UITextView {

    var placeholder: String?
    var placeholderColor: UIColor? = .Assist
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func draw(_ rect: CGRect) {
        if !hasText {
            drawPlaceholder(rect)
        }
        /// limit words code...
    }
    
    func drawPlaceholder(_ rect: CGRect) {
        guard placeholder != nil else { return }
        
        var attr = [NSAttributedString.Key: Any]()
        attr[NSAttributedString.Key.font] = font
        attr[NSAttributedString.Key.foregroundColor] = placeholderColor
        
        let x = textContainer.lineFragmentPadding + textContainerInset.left
        let y = textContainerInset.top
        let w = rect.width - x - textContainerInset.right
        let h = rect.height - y - textContainerInset.bottom
        let rect1 = CGRect(x: x, y: y, width: w, height: h)
        (placeholder! as NSString).draw(in: rect1, withAttributes: attr)
    }
    
    @objc func textDidChange() {
        setNeedsDisplay()
    }
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
}
