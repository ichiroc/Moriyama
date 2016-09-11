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
    fileprivate let event : MRYEvent!
    
    
    init(event _event: MRYEvent){
        self.event = _event
        super.init(frame: CGRect.zero, style: .plain)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented")
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
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "textCell")
        }
        
        cell!.textLabel!.text = event.datasource[(indexPath as NSIndexPath).section].eventContents[(indexPath as NSIndexPath).row].description.replacingOccurrences(of: "\n", with: " ")
        cell!.detailTextLabel?.text = event.datasource[(indexPath as NSIndexPath).section].eventContents[(indexPath as NSIndexPath).row].description
        return cell!
    }

}
