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
    private  var accessoryView : MRYEventContentsAccessoryView?
    
    init(event _event: MRYEvent, fromViewController: MRYAbstractMainViewController){
        event = _event
        eventContentsDataStore = MRYEventContentsTableDataSource(event: event)
        super.init(fromViewController: fromViewController)
        accessoryView = MRYEventContentsAccessoryView(event: event, viewController: self)
        accessoryView?.backButton.customAction = { [unowned self] in self.popViewController() }
        
        if event.calendar.allowsContentModifications {
            let openEventButton = MRYKeyboardButton(title: NSLocalizedString("Create an event", comment: ""))
            let appIcon = UIImage.init(named: "AppImageSmall.png")
            openEventButton.setImage(appIcon, forState: .Normal)
            openEventButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            if event.eventIdentifier == "" {
                [120].forEach({ (min) in
                    openEventButton.customAction = {[unowned self] in
                        self.event.endDate = NSDate(timeInterval: Double(min * 60) , sinceDate: self.event.startDate)
                        self.openEvent(self.event.startDate, endDate: self.event.endDate)
                    }
                    accessoryView?.buttons.append(openEventButton)
                })
            }else{
                openEventButton.setTitle(NSLocalizedString("Edit this event", comment: ""), forState: .Normal)
                openEventButton.customAction =  {[unowned self] in self.openEvent() }
                accessoryView?.buttons.append(openEventButton)
            }
        }

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
            "V:|[accessory(35)]-1-[table]|",
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
    
    
    func openEvent(startDate: NSDate? = nil, endDate : NSDate? = nil){
        var responder: UIResponder = self
        var urlString = "moriyama-board://?"
        if let sd = startDate, ed = endDate {
            let sdtxt = Util.sharedFormatter().stringFromDate( sd )
            let edtxt = Util.sharedFormatter().stringFromDate( ed )
            urlString += "startDate=\(sdtxt)&endDate=\(edtxt)"
        }else{
            urlString += "eventId=\(self.event.eventIdentifier)"
        }
        let url = NSURL(string: urlString)!
        while responder.nextResponder() != nil {
            responder = responder.nextResponder()!
            if responder.respondsToSelector("openURL:") == true {
                responder.performSelector("openURL:", withObject: url)
            }
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let content = event.datasource[indexPath.section].eventContents[indexPath.row]
        MRYTextDocumentProxy.proxy.insertText(content.content)
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
