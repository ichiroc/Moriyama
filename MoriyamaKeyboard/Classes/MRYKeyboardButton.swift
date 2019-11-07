//
//  MRYButton.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/26.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class MRYKeyboardButton : UIButton{

    var customAction : (() -> Void)?
    
    fileprivate var content: String?
    fileprivate var normalBackgroundColor: UIColor = UIColor.white
    fileprivate var normalTitleColor : UIColor = UIColor.black
    fileprivate var normalHighlightedColor : UIColor = UIColor.lightGray
    
    init( title: String? = nil, imageFileName : String? = nil, text: String? = nil, backgroundColor : UIColor? = nil, titleColor: UIColor? = nil, highlightedColor: UIColor? = nil,  action: (() -> Void)? = nil, round: CGFloat = 3.0){
        
        self.customAction = action
        self.content = text == nil ? title  : text
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        if let t = title{
            self.setTitle(t, for: UIControl.State())
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            normalTitleColor = titleColor == nil ? normalTitleColor : titleColor!
            self.setTitleColor(normalTitleColor, for: UIControl.State())
        }
        if let img = imageFileName {
            self.setImage(UIImage.init(named: img), for: UIControl.State())
            self.imageView?.contentMode = .scaleAspectFit
            self.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }

        if let hghtCl = highlightedColor{
            normalHighlightedColor = hghtCl
        }
        
        normalBackgroundColor = backgroundColor == nil ? normalBackgroundColor : backgroundColor!
        self.backgroundColor = normalBackgroundColor
        self.layer.cornerRadius = round
        self.addTarget(self, action: #selector(MRYKeyboardButton.touchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(MRYKeyboardButton.touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(MRYKeyboardButton.touchUpOutside), for: .touchUpOutside)
        self.addTarget(self, action: #selector(MRYKeyboardButton.touchDragOutSide), for: .touchDragOutside)
    }
    

    override init(frame: CGRect) {
        fatalError("init(frame:) is not implemented")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    @objc func touchDown(){
        self.backgroundColor = normalHighlightedColor
    }
    
    @objc func touchUpOutside(){
        resetColor()
    }
    
    @objc func touchDragOutSide(){
        resetColor()
    }
    
    func resetColor(){
        self.setTitleColor(normalTitleColor, for: UIControl.State())
        self.backgroundColor = normalBackgroundColor
    }
    
    @objc func touchUpInside(){
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

