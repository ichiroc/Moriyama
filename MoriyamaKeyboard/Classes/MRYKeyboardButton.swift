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
    
    init( title: String, text: String?){
        _text = text
        super.init(frame: CGRectZero)
        self.setTitle(title, forState: .Normal)
        self.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.backgroundColor = UIColor.whiteColor()
        self.addTarget(self, action: "insertText", forControlEvents: .TouchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.layer.cornerRadius = 3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func insertText(){
        if let text = _text{
            MRYTextDocumentPRoxy.proxy.insertText(text)
        }
    }
}

