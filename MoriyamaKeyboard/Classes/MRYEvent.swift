//
//  MRYEvent.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/10.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKit

class MRYEvent: NSObject {
    let _event : EKEvent
    var calendar : EKCalendar  {
        get{ return _event.calendar }
    }
    init( event: EKEvent){
        _event = event
    }
    
}
