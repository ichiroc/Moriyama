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
    @IBOutlet var reviewButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        supportButton.addTarget(self, action: #selector(ViewController.tappedSupportButton), for: .touchUpInside)
        reviewButton.addTarget(self, action: #selector(ViewController.tappedReviewButton), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tappedReviewButton(){
        let url : URL! = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1087163548")
        let app = UIApplication.shared
        if(app.canOpenURL(url)){
            app.openURL(url)
        }
    }
    
    func tappedSupportButton(){
        let url : URL! = URL(string: "https://twitter.com/apptboard")
        let app = UIApplication.shared
        if(app.canOpenURL(url)){
            app.openURL(url)
        }
    }

}

