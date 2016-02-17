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
    let descriptionTexts = [ "「設定」アプリを開き、「一般」> 「キーボード」を開きます",
    "「キーボード」 > 「新しいキーボードを追加...」を開きます",
    "「ApptBoard」を選択",
    "「ApptBoard」をもう一度選択",
    "「フルアクセスを許可」をオンにして許可を選択"]
    var maxPageIndex = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        // Do any additional setup after loading the view.
        let content = storyboard?.instantiateViewControllerWithIdentifier("TutorialContent")
        if let content0 = content! as? MRYTutorialContentViewController{
            let v = content0.view
            content0.pageIndex = 0
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
                let v = content0.view
                content0.pageIndex = current.pageIndex + 1
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
            let v = content0.view
            content0.pageIndex = current.pageIndex - 1
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
