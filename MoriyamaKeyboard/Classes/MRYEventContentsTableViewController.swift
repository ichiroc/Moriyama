//
//  MRYTimeDetailViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/13.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit


class MRYEventContentsTableViewController:
    MRYAbstractMainViewController, UITableViewDelegate{
    var eventContentsDataStore : MRYEventContentsTableDataSource!
    private var event: MRYEvent!
    var views : [String: UIView] = [:]
    
    init(event _event: MRYEvent, fromViewController: MRYAbstractMainViewController){
        event = _event
        eventContentsDataStore = MRYEventContentsTableDataSource(event: event)
        super.init(fromViewController: fromViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        let tableHorizonalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[table]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: METRICS,
            views: views )
        self.view.addConstraints(tableHorizonalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[back(35)]-1-[table]|",
            options: [.AlignAllCenterX, .AlignAllLeading, .AlignAllTrailing] ,
            metrics: METRICS,
            views: views)
        self.view.addConstraints(verticalConstraints)
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false

        // Do any additional setup after loading the view.
        let backButton = MRYKeyboardButton(title: NSLocalizedString("Back", comment: "Back"),titleColor: UIColor.blueColor() , action:  { self.popViewController() },round: 0 )
        self.view.addSubview(backButton)
        let tableView = MRYEventContentsTableView(event: event! )
        tableView.delegate = self
        tableView.dataSource = eventContentsDataStore
        self.view.addSubview(tableView)
        views = [ "back": backButton,
            "table": tableView]

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let content = event.datasource[indexPath.section].eventContents[indexPath.row]
        if let openEvent = content.openEvent {
            openEvent(vc:self)
        }else{
            MRYTextDocumentProxy.proxy.insertText(content.Content)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
