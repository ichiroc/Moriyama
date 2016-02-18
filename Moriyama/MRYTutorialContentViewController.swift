//
//  MRYTutorialContentViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/17.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYTutorialContentViewController: UIViewController {

    var pageIndex : Int = 0
   
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var descriptionImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        closeButton.addTarget(self, action: "tappedCloseButton", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedCloseButton(){
        self.dismissViewControllerAnimated(true, completion: nil  )
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
