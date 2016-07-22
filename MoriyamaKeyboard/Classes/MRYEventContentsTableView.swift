//
//  MRYEventContentsTableView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/13.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYEventContentsTableView: UITableView,
    UITableViewDelegate, UITableViewDataSource{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    private let event : MRYEvent!
    
    
    init(event _event: MRYEvent){
        self.event = _event
        super.init(frame: CGRectZero, style: .Plain)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
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
        
        cell!.textLabel!.text = event.datasource[indexPath.section].eventContents[indexPath.row].description.stringByReplacingOccurrencesOfString("\n", withString: " ")
        cell!.detailTextLabel?.text = event.datasource[indexPath.section].eventContents[indexPath.row].description
        return cell!
    }

}
