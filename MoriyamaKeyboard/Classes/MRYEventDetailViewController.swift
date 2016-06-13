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
    private var eventContentsDataStore : MRYEventContentsTableDataSource!
    private var event: MRYEvent!
    private var views : [String: UIView] = [:]
    private  var accessoryView : MRYEventContentsAccessoryView?
    
    init(event _event: MRYEvent, fromViewController: MRYAbstractMainViewController){
        event = _event
        eventContentsDataStore = MRYEventContentsTableDataSource(event: event)
        super.init(fromViewController: fromViewController)
        accessoryView = MRYEventContentsAccessoryView(event: event, viewController: self)
        accessoryView?.backButton.customAction = { [unowned self] in self.popViewController() }
        accessoryView?.openEventButton.customAction = { [unowned self] in
            self.openEvent(self.event.startDate,endDate:self.event.endDate)
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
    
    
    func openEvent(startDate: NSDate, endDate : NSDate){
        var responder: UIResponder = self
        var urlString = "moriyama-board://?"

        if self.event.eventIdentifier != "" {
            let escapedEventId = self.event.eventIdentifier.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
            urlString += "eventId=\(escapedEventId!)"
        }
        
        let sdtxt = Util.sharedFormatter().stringFromDate( startDate )
        let edtxt = Util.sharedFormatter().stringFromDate( endDate )
        urlString += "&startDate=\(sdtxt)&endDate=\(edtxt)"

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
