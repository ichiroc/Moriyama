//
//  MRYTimeDetailTableView.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/13.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYTimeDetailTableView: UITableView,
    UITableViewDelegate, UITableViewDataSource{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let event : MRYEvent!
    init(event _event: MRYEvent){
        self.event = _event
        super.init(frame: CGRectZero, style: .Plain)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        event = nil
        super.init(coder: aDecoder)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return event.datasource.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.datasource[section].data.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return event.datasource[section].title
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("textCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "textCell")
        }
        
        cell!.textLabel!.text = event.datasource[indexPath.section].data[indexPath.row].text.stringByReplacingOccurrencesOfString("\n", withString: " ")
        cell!.detailTextLabel?.text = event.datasource[indexPath.section].data[indexPath.row].title
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        MRYTextDocumentProxy.proxy.insertText(event.datasource[indexPath.section].data[indexPath.row].text)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
