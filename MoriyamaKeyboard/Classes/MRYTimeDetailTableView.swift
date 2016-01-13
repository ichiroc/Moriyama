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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return event.data.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var ret = ""
        switch section {
        case 0:
            ret = "General time items"
        case 1:
            ret = "Event information"
        default:
            break
        }
        return ret
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("textCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "textCell")
        }
       
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            case 0:
                cell!.textLabel!.text = Util.string(NSDate(), format: "MMdd")
                // TODO: Return time at position tapped in timeline.
//            case 1:
//                cell!.textLabel!.text = Util.string(NSDate(), format: "HHmm")
            default:
                break
            }
        case 1:
            cell!.textLabel!.text =  event.data[indexPath.row].0
            cell!.detailTextLabel!.text = event.data[indexPath.row].1
        default:
            break
        }
        
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        MRYTextDocumentProxy.proxy.insertText(event.data[indexPath.row].0)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
