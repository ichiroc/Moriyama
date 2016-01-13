//
//  MRYTimeDetailViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/13.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYTimeDetailViewController: UIViewController {
    var _event: MRYEvent?
    
    init( event: MRYEvent){
        _event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let doneButton = MRYKeyboardButton(title: "Done",  action:  { () -> Void in
            self.dissmissSelf() } )
        self.view.addSubview(doneButton)
        let tableView = MRYTimeDetailTableView(event: _event! )
        self.view.addSubview(tableView)
        let views = [ "done": doneButton,
        "table": tableView]
        let tableHorizonalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[table]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views )
        self.view.addConstraints(tableHorizonalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[table]-[done]-|",
            options: [.AlignAllCenterX, .AlignAllLeading, .AlignAllTrailing] ,
            metrics: nil,
            views: views)
        self.view.addConstraints(verticalConstraints)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dissmissSelf(){
        self.dismissViewControllerAnimated(true, completion: nil )
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
