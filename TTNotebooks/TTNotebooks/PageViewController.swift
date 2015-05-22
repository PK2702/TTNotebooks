//
//  PageViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/21/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    
    // MARK: -Variables and Constants
    
    var page: Page!
    
    @IBOutlet weak var pageView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = page.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
