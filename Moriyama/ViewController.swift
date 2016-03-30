//
//  ViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2015/12/25.
//  Copyright © 2015年 Ichiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var supportButton: UIButton!
    private let supportURL : NSURL! = NSURL(string: "https://twitter.com/apptboard")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        supportButton.addTarget(self, action: #selector(ViewController.tappedSupportButton), forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tappedSupportButton(){
        let url = NSURL(string: "https://twitter.com/apptboard")
        let app = UIApplication.sharedApplication()
        if(app.canOpenURL(supportURL)){
            app.openURL(url!)
        }
    }

}

