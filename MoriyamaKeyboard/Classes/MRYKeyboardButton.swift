//
//  MRYButton.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/26.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class MRYKeyboardButton : UIButton{
    private var content: String?
    var customAction : (() -> Void)?
    private var normalBackgroundColor: UIColor = UIColor.whiteColor()
    private var normalTitleColor : UIColor = UIColor.blackColor()
    private var normalHighlightedColor : UIColor = UIColor.lightGrayColor()
    
    init( title: String? = nil, imageFileName : String? = nil, text: String? = nil, backgroundColor : UIColor? = nil, titleColor: UIColor? = nil, highlightedColor: UIColor? = nil,  action: (() -> Void)? = nil, round: CGFloat = 3.0){
        
        self.customAction = action
        self.content = text == nil ? title  : text
        super.init(frame: CGRectZero)
        self.translatesAutoresizingMaskIntoConstraints = false
        if let t = title{
            self.setTitle(t, forState: .Normal)
            self.titleLabel?.font = UIFont.systemFontOfSize(16)
            normalTitleColor = titleColor == nil ? normalTitleColor : titleColor!
            self.setTitleColor(normalTitleColor, forState: .Normal)
        }
        if let img = imageFileName {
            self.setImage(UIImage.init(named: img), forState: .Normal)
            self.imageView?.contentMode = .ScaleAspectFit
            self.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }

        if let hghtCl = highlightedColor{
            normalHighlightedColor = hghtCl
        }
        
        normalBackgroundColor = backgroundColor == nil ? normalBackgroundColor : backgroundColor!
        self.backgroundColor = normalBackgroundColor
        self.layer.cornerRadius = round
        self.addTarget(self, action: #selector(MRYKeyboardButton.touchUpInside), forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(MRYKeyboardButton.touchDown), forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(MRYKeyboardButton.touchUpOutside), forControlEvents: .TouchUpOutside)
        self.addTarget(self, action: #selector(MRYKeyboardButton.touchDragOutSide), forControlEvents: .TouchDragOutside)
    }
    

    override init(frame: CGRect) {
        fatalError("init(frame:) is not implemented")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    func touchDown(){
        self.backgroundColor = normalHighlightedColor
    }
    
    func touchUpOutside(){
        resetColor()
    }
    
    func touchDragOutSide(){
        resetColor()
    }
    
    func resetColor(){
        self.setTitleColor(normalTitleColor, forState: .Normal)
        self.backgroundColor = normalBackgroundColor
    }
    
    func touchUpInside(){
        resetColor()
        
        if let action = customAction {
            action()
            return
        }
        if let text = content{
            MRYTextDocumentProxy.proxy.insertText(text)
        }
    }
}

