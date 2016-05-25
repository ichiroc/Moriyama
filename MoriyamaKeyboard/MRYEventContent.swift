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
    var content: String
    var openEvent : (( vc: UIViewController ) -> Void)? = nil
    init(description: String, content: String){
        self.description = description
        self.content = content
    }
}