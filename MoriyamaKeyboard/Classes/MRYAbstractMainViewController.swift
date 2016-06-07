//
//  MRYAbstractMainViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/28.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYAbstractMainViewController: UIViewController {

    var previousViewController : MRYAbstractMainViewController?
    
    convenience init(){
        self.init(fromViewController: nil)
    }
    init( fromViewController: MRYAbstractMainViewController?){
        previousViewController = fromViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func pushViewController(toViewController: MRYAbstractMainViewController){
        KeyboardViewController.sharedInstance.transientToViewController(toViewController)
    }
    
    func popViewController(){
        if let prev = previousViewController{
            KeyboardViewController.sharedInstance.transientToViewController(prev)
        }
    }
    
    func viewDidChangeOrientation( orientation: KeyboardViewController.Orientation ){
       // Default behavior is nothign, implement in subclass.
    }
    
    
}