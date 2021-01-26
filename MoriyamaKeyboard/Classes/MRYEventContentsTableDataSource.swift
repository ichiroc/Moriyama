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
    
    fileprivate let event : MRYEvent
    
    
    init(event _event: MRYEvent){
        event = _event
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return event.datasource.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.datasource[section].eventContents.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return event.datasource[section].description
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "textCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "textCell")
        }
        
        cell!.textLabel!.text = event.datasource[(indexPath as NSIndexPath).section].eventContents[(indexPath as NSIndexPath).row].content.replacingOccurrences(of: "\n", with: " ")
        cell!.detailTextLabel?.text = event.datasource[(indexPath as NSIndexPath).section].eventContents[(indexPath as NSIndexPath).row].description
        return cell!
    }


}
