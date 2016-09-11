//
//  Util.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/13.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class Util: NSObject {

    class func string(_ date: Date, format: String, locale: Locale = Locale.current) -> String{
        if let formatString = DateFormatter.dateFormat(
            fromTemplate: format,
            options: 0,
            locale: locale    ){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = formatString
                dateFormatter.locale = locale
                let formattedDateString = dateFormatter.string(from: date)
                return formattedDateString
        }
        return ""
    }
    
    class func removeHms( _ date : Date ) -> Date {
        let cal = Calendar.current
        let comp = (cal as NSCalendar).components([ .year, .month, .day ], from: date)
        return cal.date(from: comp)!
    }
 
    class func sharedFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm"
        return formatter
    }
}
