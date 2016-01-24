//
//  MRYButton.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/26.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class MRYKeyboardButton : UIButton{
    var _text: String?
    var customAction : (() -> Void)?
    let normalBackgroundColor: UIColor = UIColor.whiteColor()
    let normalTitleColor : UIColor = UIColor.blackColor()

    init( title: String,
        text: String? = nil,
        backgroundColor : UIColor? = nil,
        titleColor: UIColor? = nil,
        action: (() -> Void)? = nil,
        round: Bool = true){
            customAction = action
            if let txt = text {
                _text = txt
            }else{
                _text = title
            }
            super.init(frame: CGRectZero)
            backgroundColor.map{ normalBackgroundColor = $0 }
            titleColor.map{ normalTitleColor = $0 }
            self.setTitle(title, forState: .Normal)
            self.titleLabel?.font = UIFont.systemFontOfSize(16)
            self.setTitleColor(normalTitleColor, forState: .Normal)
            self.backgroundColor = normalBackgroundColor
            if round{
                self.layer.cornerRadius = 3
            }
            self.addTarget(self, action: "touchUpInside", forControlEvents: .TouchUpInside)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.addTarget(self, action: "touchDown", forControlEvents: .TouchDown)
            self.addTarget(self, action: "touchUpOutside", forControlEvents: .TouchUpOutside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func touchDown(){
        self.setTitleColor(normalBackgroundColor, forState: .Normal)
        self.backgroundColor = normalTitleColor
    }
    
    func touchUpOutside(){
        resetColor()
    }
    
    private func resetColor(){
        self.setTitleColor(normalTitleColor, forState: .Normal)
        self.backgroundColor = normalBackgroundColor
    }
    
    func touchUpInside(){
        resetColor()
        
        if let action = customAction {
            action()
            return
        }
        if let text = _text{
            MRYTextDocumentProxy.proxy.insertText(text)
        }
    }
}

