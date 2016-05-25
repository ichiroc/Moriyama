//
//  MRYEventContent.swift
//  Moriyama
//
//  Created by Ichiro on 2016/03/09.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit


struct MRYEventContent{
    var description: String
    var Content: String
    var openEvent : (( vc: UIViewController ) -> Void)? = nil
    init(description: String, Content: String){
        self.description = description
        self.Content = Content
    }
}