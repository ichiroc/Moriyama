//
//  MRYTimeDetailViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/13.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit


class MRYEventDetailViewController:
    MRYAbstractMainViewController, UITableViewDelegate{
    fileprivate var eventContentsDataStore : MRYEventContentsTableDataSource!
    fileprivate var event: MRYEvent!
    fileprivate var views : [String: UIView] = [:]
    fileprivate  var accessoryView : MRYEventContentsAccessoryView?
    
    init(event _event: MRYEvent, fromViewController: MRYAbstractMainViewController){
        event = _event
        eventContentsDataStore = MRYEventContentsTableDataSource(event: event)
        super.init(fromViewController: fromViewController)
        accessoryView = MRYEventContentsAccessoryView(event: event, viewController: self)
        accessoryView?.backButton.customAction = { [unowned self] in self.popViewController() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tableHorizonalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[table]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: METRICS,
            views: views )
        self.view.addConstraints(tableHorizonalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[accessory(35)]-1-[table]|",
            options: [.alignAllCenterX, .alignAllLeading, .alignAllTrailing] ,
            metrics: METRICS,
            views: views)

        self.view.addConstraints(verticalConstraints)
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false

        // Do any additional setup after loading the view.

        let tableView = MRYEventContentsTableView(event: event! )
        tableView.delegate = self
        tableView.dataSource = eventContentsDataStore
        self.view.addSubview(tableView)
        self.view.addSubview(accessoryView!)
        views = [ "accessory": accessoryView!,
                  "table": tableView]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = event.datasource[(indexPath as NSIndexPath).section].eventContents[(indexPath as NSIndexPath).row]
        MRYTextDocumentProxy.proxy.insertText(content.content)
        tableView.deselectRow(at: indexPath, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
