//
//  Util.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/13.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class Util: NSObject {

    class func string(date: NSDate, format: String, locale: NSLocale = NSLocale.currentLocale()) -> String{
        if let formatString = NSDateFormatter.dateFormatFromTemplate(
            format,
            options: 0,
            locale: locale    ){
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = formatString
                dateFormatter.locale = locale
                let formattedDateString = dateFormatter.stringFromDate(date)
                return formattedDateString
        }
        return ""
    }
}
