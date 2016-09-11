//
//  MRYAbstractMainViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/01/28.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYAbstractMainViewController: UIViewController {

    fileprivate var previousViewController : MRYAbstractMainViewController?
    
    convenience init(){
        self.init(fromViewController: nil)
    }
    init( fromViewController: MRYAbstractMainViewController?){
        previousViewController = fromViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented.")
    }
    func pushViewController(_ toViewController: MRYAbstractMainViewController){
        KeyboardViewController.sharedInstance.transientToViewController(toViewController)
    }
    
    func popViewController(){
        if let prev = previousViewController{
            KeyboardViewController.sharedInstance.transientToViewController(prev)
        }
    }
    
    func viewDidChangeOrientation( _ orientation: KeyboardViewController.Orientation ){
       // Default behavior is nothing, implement in subclass.
    }
    
    
}
