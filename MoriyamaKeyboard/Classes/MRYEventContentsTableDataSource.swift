//
//  MRYEventContentsTableDataSource.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/11.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYEventContentsTableDataSource:
    NSObject ,
    UITableViewDataSource{
    
    let event : MRYEvent
    init(event _event: MRYEvent){
        event = _event
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return event.datasource.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.datasource[section].eventContents.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return event.datasource[section].description
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("textCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "textCell")
        }
        
        cell!.textLabel!.text = event.datasource[indexPath.section].eventContents[indexPath.row].Content.stringByReplacingOccurrencesOfString("\n", withString: " ")
        cell!.detailTextLabel?.text = event.datasource[indexPath.section].eventContents[indexPath.row].description
        return cell!
    }


}
