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
        pageView.contentSize = CGSize(width: 1000, height: 1000)
        title = page.name
        println("Number of figures \(page.figures.count)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("Tomos te pasaste con la memoria")
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Drawing Methods
    
    /** Recieves a Figure to insert in the Scroll View */
    @IBAction func insertFigure(segue: UIStoryboardSegue){
        println("Entered in this method")
        if let svc = segue.sourceViewController as? InsertFigureMenuTableViewController {
            println("Recognized the controller")
            if let figure = svc.figureToInsert {
                pageView.addSubview(figure)
                println("Inserted figure with origin: \(figure.frame.origin.x), \(figure.frame.origin.y) \n width:\(figure.frame.size.width) \n width:\(figure.frame.size.height)")
            }
        }
    }
    
    // MARK: - Navigation

    private struct SegueIdentifiers {
        static let ShowInsertMenuSegueIdentifier = "Show Insert Menu"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch (identifier) {
            case SegueIdentifiers.ShowInsertMenuSegueIdentifier:
                if let dvc = segue.destinationViewController as? InsertFigureMenuTableViewController {
                    dvc.page = page
                    let upperLeftPoint = pageView.contentOffset
                    dvc.insertWindow = CGRectMake(upperLeftPoint.x, upperLeftPoint.y, view.bounds.width, view.bounds.height)
                }
            default:
                break
            }
        }
    }
}
