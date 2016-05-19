//

//  MRYTutorialPageViewController.swift
//  Moriyama
//
//  Created by Ichiro on 2016/02/16.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

import UIKit

class MRYTutorialPageViewController: UIPageViewController,
UIPageViewControllerDataSource,UIPageViewControllerDelegate{

    var controllers : [UIViewController] = []
    var pageIndex = 0
    let descriptionTexts = [
        NSLocalizedString("This is instruction which how to add ApptBoard keyboard. First, open 'Setting' from home." , comment: "") , // 0
        NSLocalizedString("Choose 'Keyboard'" , comment: ""), // 2
        NSLocalizedString("Choose 'Keyboards'" , comment: ""), // 3
        NSLocalizedString("Choose 'Add New Keyboard..'" , comment: ""), // 4
        NSLocalizedString("Choose 'ApptBoard'" , comment: ""), // 5
        NSLocalizedString("Choose 'ApptBoard' again." , comment: ""),  // 6
        NSLocalizedString("Enable 'Allow Full Access' to check appointments with a keyboard." , comment: ""), // 9
        NSLocalizedString("Warning will be shown. Choose 'Allow'. We don't send your input data if you allowed.", comment: "") , // 10
        NSLocalizedString("If 'Allow Full Access' is enabled, It's done. Use it by tap 🌐 button." , comment: ""), // 11
        NSLocalizedString("[NOTICE] To check appointments with a keyboard, You must confirm that appointments is shown on default Calendar app.", comment: "") // 12

    ]
    var maxPageIndex = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        // Do any additional setup after loading the view.
        let content = storyboard?.instantiateViewControllerWithIdentifier("TutorialContent")
        if let content0 = content! as? MRYTutorialContentViewController{
            _ = content0.view // for load views.
            content0.pageIndex = 0
            content0.descriptionImage.image = UIImage(named: "TutorialImage0.png")
            content0.descriptionLabel?.text = descriptionTexts[0]
        }
        
        controllers = [content! ]
        self.setViewControllers(controllers,
            direction: .Forward,
            animated: true,
            completion: nil  )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return descriptionTexts.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        let content = pageViewController.viewControllers?.first as! MRYTutorialContentViewController
        return content.pageIndex
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            let current = viewController as! MRYTutorialContentViewController
            if current.pageIndex >= descriptionTexts.count - 1 {
                return nil
            }
            let content = storyboard?.instantiateViewControllerWithIdentifier("TutorialContent")
            if let content0 = content! as? MRYTutorialContentViewController{
                _ = content0.view
                content0.pageIndex = current.pageIndex + 1
                content0.descriptionImage.image = UIImage(named: "TutorialImage\(content0.pageIndex).png")
                content0.descriptionLabel.text = descriptionTexts[content0.pageIndex]
            }
            return content!
    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let current = viewController as! MRYTutorialContentViewController
        if current.pageIndex <= 0{
            return nil
        }
        let content = storyboard?.instantiateViewControllerWithIdentifier("TutorialContent")
        if let content0 = content! as? MRYTutorialContentViewController{
            _ = content0.view
            content0.pageIndex = current.pageIndex - 1
            content0.descriptionImage.image = UIImage(named: "TutorialImage\(content0.pageIndex).png")
            content0.descriptionLabel.text = descriptionTexts[content0.pageIndex]
        }
        return content!
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
