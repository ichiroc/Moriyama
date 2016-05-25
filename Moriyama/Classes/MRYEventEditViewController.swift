//
//  MRYEventEditViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/05/25.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit
import EventKitUI
class MRYEventEditViewController: EKEventEditViewController,EKEventEditViewDelegate {

    var evnetStore : EKEventStore?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func eventEditViewController(controller: EKEventEditViewController, didCompleteWithAction action: EKEventEditViewAction) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
