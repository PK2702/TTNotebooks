//
//  PageViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/21/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit
import CoreData

class PageViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIDynamicAnimatorDelegate, FigureViewDelegate {
    
    // MARK: -Variables and Constants
    
    /** The model whose information is being displayed in the View */
    var page: Page!
    
    /** The figures of the Page */
    private var figures : [Figure] {
        get {
            if let figrs = page.figures.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Figure.YOrigin, ascending: true, selector: "compare:")]) as? [Figure] {
                return figrs
            }
            return [Figure]()
        }
    }
    
    /** The scrollview where all of the view will be inserted */
    @IBOutlet weak var pageView: UIScrollView!
    
    /** The dynamic animator where all of the behaviors will be added */
    lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)
    
    /** The FigureView that is currently being edited */
    var figureBeingEdited: FigureView? {
        didSet {
            if let figure = figureBeingEdited {
                figure.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "moveFigure:"))
            }
        }
    }
    
    /** The attachment behavior used to move the FigureView that is being edited */
    var attachmentBehavior: UIAttachmentBehavior?
    
    // MARK: - Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.contentSize = CGSize(width: 1000, height: 1000)
        title = page.name
        dynamicAnimator.delegate = self
        println("Number of figures \(page.figures.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("Tomos te pasaste con la memoria")
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Drawing Methods
    
    /** Recieves a Figure to insert in the Scroll View */
    @IBAction func insertFigure(segue: UIStoryboardSegue) {
        println("Entered in this method")
        if let svc = segue.sourceViewController as? InsertFigureMenuTableViewController {
            println("Recognized the controller")
            if let figure = svc.figureToInsert {
                figure.delegate = self
                figure.index = figures.count
                pageView.addSubview(figure)
                println("Inserted figure with origin: \(figure.frame.origin.x), \(figure.frame.origin.y) \n width:\(figure.frame.size.width) \n width:\(figure.frame.size.height)")
            }
        }
    }
    
    // MARK: - Gestures
    
    func moveFigure(panGesture: UIPanGestureRecognizer) {
        let gesturePoint = panGesture.locationInView(self.view)
        if let figure = figureBeingEdited {
            switch (panGesture.state){
            case UIGestureRecognizerState.Began:
                println("Began")
                attachmentBehavior = UIAttachmentBehavior(item: figure, attachedToAnchor: gesturePoint)
                attachmentBehavior?.length = 0.0
                dynamicAnimator.addBehavior(attachmentBehavior!)
            case UIGestureRecognizerState.Changed:
                println("Changed")
                if let attachment = attachmentBehavior {
                    attachment.anchorPoint = gesturePoint
                }
            case UIGestureRecognizerState.Ended:
                println("Ended")
                if let attachment = attachmentBehavior {
                    dynamicAnimator.removeBehavior(attachment)
                    updateCoordinatesOfFigureWithFigureView(figure)
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Figure Update Methods
    
    private func updateCoordinatesOfFigureWithFigureView(figureView: FigureView) {
        if let i = figureView.index {
            let figure = figures[i]
            figure.yOrigin = figureView.frame.origin.y
            figure.xOrigin = figureView.frame.origin.x
        }
    }
    
    // MARK: - FigureView Delegate Methods
    
    func selectedFigureView(figureView: FigureView, editing: Bool) {
        println("Touched Figure \(editing.description)")
        if !editing {
            figureBeingEdited = nil
        } else {
            figureBeingEdited = figureView
        }
    }
    
    // MARK: - UIPopover Delegate Methods
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }

    
    // MARK: - Navigation
    
    /** All of the Segue Identifiers that this View Controller has */
    private struct SegueIdentifiers {
        static let ShowInsertMenuSegueIdentifier = "Show Insert Menu"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch (identifier) {
            case SegueIdentifiers.ShowInsertMenuSegueIdentifier:
                if let dvc = segue.destinationViewController as? InsertFigureMenuTableViewController {
                    if let ppc = dvc.popoverPresentationController {
                        ppc.delegate = self
                    }
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
