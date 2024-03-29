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

    fileprivate var controllers : [UIViewController] = []
    fileprivate var pageIndex = 0
    fileprivate let descriptionTexts = [
        NSLocalizedString("This is instruction which how to add ApptBoard keyboard. First, open 'Setting' from home." , comment: "") , // 0
        NSLocalizedString("Choose 'General'" , comment: ""), // 2
        NSLocalizedString("Choose 'Keyboard'" , comment: ""), // 2
        NSLocalizedString("Choose 'Keyboards'" , comment: ""), // 3
        NSLocalizedString("Choose 'Add New Keyboard..'" , comment: ""), // 4
        NSLocalizedString("Choose 'ApptBoard'" , comment: ""), // 5
        NSLocalizedString("Choose 'ApptBoard' again." , comment: ""),  // 6
        NSLocalizedString("Enable 'Allow Full Access' to check appointments with a keyboard." , comment: ""), // 9
        NSLocalizedString("Warning will be shown. Choose 'Allow'. We don't send your input data if you allowed.", comment: "") , // 10
        NSLocalizedString("If 'Allow Full Access' is enabled, It's done. Tap 🌐 on the keyboard to switch to ApptBoard when typing text in email, message applications, etc.." , comment: ""), // 11
        NSLocalizedString("[NOTICE] To check appointments with a keyboard, You must confirm that appointments is shown on default Calendar app.", comment: "") // 12

    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        // Do any additional setup after loading the view.
        let content = storyboard?.instantiateViewController(withIdentifier: "TutorialContent")
        if let content0 = content! as? MRYTutorialContentViewController{
            _ = content0.view // for load views.
            content0.pageIndex = 0
            content0.descriptionImage.image = UIImage(named: "TutorialImage0.png")
            content0.descriptionLabel?.text = descriptionTexts[0]
        }
        
        controllers = [content! ]
        self.setViewControllers(controllers,
            direction: .forward,
            animated: true,
            completion: nil  )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return descriptionTexts.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        let content = pageViewController.viewControllers?.first as! MRYTutorialContentViewController
        return content.pageIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
            let current = viewController as! MRYTutorialContentViewController
            if current.pageIndex >= descriptionTexts.count - 1 {
                return nil
            }
            return tutorialContentViewControllerAtPageIndex(current.pageIndex + 1)
    }

    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let current = viewController as! MRYTutorialContentViewController
        if current.pageIndex <= 0{
            return nil
        }
        return tutorialContentViewControllerAtPageIndex(current.pageIndex - 1)
    }
    
    fileprivate func tutorialContentViewControllerAtPageIndex(_ pageIndex :Int ) -> MRYTutorialContentViewController{
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "TutorialContent")
        if let contentVC0 = contentVC as? MRYTutorialContentViewController{
            _ = contentVC0.view
            contentVC0.pageIndex = pageIndex
            contentVC0.descriptionImage.image = UIImage(named: "TutorialImage\(contentVC0.pageIndex).png")
            contentVC0.descriptionLabel.text = descriptionTexts[contentVC0.pageIndex]
            return contentVC0
        }
        fatalError("Stroyboard coludn't instantiate TutorialContentViewController.")
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
