//
//  PageViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/21/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit
import CoreData

class PageViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIDynamicAnimatorDelegate, FigureViewDelegate, ColorChooserDelegate {
    
    // MARK: -Variables and Constants
    
    /** The model whose information is being displayed in the View */
    var page: Page!
    
    /** The figures of the Page */
    private var figures : [Figure] {
        get {
            if let figrs = page.figures.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Figure.OrderInPage, ascending: true, selector: "compare:")]) as? [Figure] {
                return figrs
            }
            return [Figure]()
        }
    }
    
    /** The scrollview where all of the view will be inserted */
    @IBOutlet weak var pageView: UIScrollView!
    
    /** The dynamic animator where all of the behaviors will be added */
    lazy var dynamicAnimator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.view)
    
    /** The gesture recognizer that will handle the moving of the figure being edited */
    lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "moveFigure:")
    
    /** The gesture recognizer that will handle the pinching of the figure being edited */
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchFigure:")
    
    /** The FigureView that is currently being edited */
    var figureBeingEdited: FigureView?
    
    /** The color chooser menu. If this variable is not nil then it means that the menu is being displayed */
    var colorChooserView: ColorChooserView?
    
    /** The attachment behavior used to move the FigureView that is being edited */
    var attachmentBehavior: UIAttachmentBehavior?
    
    /** The controller in charge of presenting the Menu Controller for a long pressed on a Figure */
    var menuController: UIMenuController!
    
    // MARK: - Localized Strings
    
    /** List of all the Localized Strings of this class */
    private struct LStrings {
        static let DeleteActionTitle = NSLocalizedString("Delete", comment: "This is the title of the action in the menu interface that deletes the figure being edited")
        static let FillColorActionTitle = NSLocalizedString("Color", comment: "This is the title of the action in the menu interface that changes the figure's color, without changing its stroke")
        static let StrokeColorActionTitle = NSLocalizedString("Stroke Color", comment: "This is the title of the action in the menu interface that changes the stroke color of the figure")
        static  let LineWidthActionTitle = NSLocalizedString("Line Width", comment: "This is the title of the action in the menu interface that changes the line width of the stroke of the figure")
    }
    
    // MARK: - Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenuController()
        pageView.contentSize = CGSize(width: 1000, height: 1000)
        title = page.name
        dynamicAnimator.delegate = self
        if figures.count > 0 {
            drawFigures()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: "touchedScrollView:")
        pageView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("Tomos te pasaste con la memoria")
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        page.managedObjectContext?.save(nil)
    }
    
    // MARK: - Menu Controller
    
    /** Sets up the Menu Controller to have the custom actions */
    private func configureMenuController() {
        menuController = UIMenuController.sharedMenuController()
        let deleteMenuItem = UIMenuItem(title: LStrings.DeleteActionTitle, action: "deleteEditedFigure:")
        let colorFillMenuItem = UIMenuItem(title: LStrings.FillColorActionTitle, action: "changeFigureColor:")
        let colorStrokeMenutItem = UIMenuItem(title: LStrings.StrokeColorActionTitle, action: "changeFigureStrokeColor:")
        menuController.menuItems = [deleteMenuItem, colorFillMenuItem, colorStrokeMenutItem]
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        switch(action) {
        case "deleteEditedFigure:", "changeFigureColor:", "changeFigureStrokeColor:" :
            return true
        default:
            return false
        }
    }
    
    /** Deletes the figure that is being edited */
    func deleteEditedFigure(sender: UIMenuItem) {
        if let editedFigure = figureBeingEdited {
            let fetchRequest = NSFetchRequest(entityName: ModelConstants.Figure.EntityName)
            fetchRequest.predicate = NSPredicate(format: "\(ModelConstants.Figure.OrderInPage) == %d", editedFigure.index)
            if let figure = page.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)?.first as? Figure {
                page.managedObjectContext?.deleteObject(figure)
                page.managedObjectContext?.save(nil)
                editedFigure.removeFromSuperview()
            }
        }
    }
    
    /** Displays the view in charge of changing the fill color of the figure */
    func changeFigureColor(sender: UIMenuItem) {
        if let editedFigure = figureBeingEdited {
            let fetchRequest = NSFetchRequest(entityName: ModelConstants.Figure.EntityName)
            fetchRequest.predicate = NSPredicate(format: "\(ModelConstants.Figure.OrderInPage) == %d", editedFigure.index)
            if let figure = page.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)?.first as? Figure {
                colorChooserView?.removeFromSuperview()
                let colorChooserHeight: CGFloat = 100.0
                let colorChooserWidth = fmin(view.frame.size.width, 600)
                let colorChView = ColorChooserView(frame: CGRectMake(0.0, view.frame.size.height - colorChooserHeight, colorChooserWidth, colorChooserHeight), type: .FigureFillColor, value: figure.alpha.floatValue)
                colorChView.delegate = self
                colorChooserView = colorChView
                view.addSubview(colorChooserView!)
            }
        }
    }
    
    /** Displays the view in charge of changing the stroke color of the figure */
    func changeFigureStrokeColor(sender: UIMenuItem) {
        if let editedFigure = figureBeingEdited {
            let fetchRequest = NSFetchRequest(entityName: ModelConstants.Figure.EntityName)
            fetchRequest.predicate = NSPredicate(format: "\(ModelConstants.Figure.OrderInPage) == %d", editedFigure.index)
            if let figure = page.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)?.first as? Figure {
                colorChooserView?.removeFromSuperview()
                let colorChooserHeight: CGFloat = 100.0
                let colorChooserWidth = fmin(view.frame.size.width, 600)
                let colorChView = ColorChooserView(frame: CGRectMake(0.0, view.frame.size.height - colorChooserHeight, colorChooserWidth, colorChooserHeight), type: .FigureStrokeColor, value: figure.strokeLineWidth.floatValue)
                colorChView.delegate = self
                colorChooserView = colorChView
                view.addSubview(colorChooserView!)
            }
        }
    }
    
    /** Displays the view in charge of changing the line width of the stroke in a Figure */
    func changeFigureLineWidth(sender: UIMenuItem) {
        
    }
    
    /**
    Displays the Menu Controller attached to the figure being edited
    
    :param: frame The frame to which the MenuController will be attached
    */
    func showMenuController(frame: CGRect) {
        if let editedFigure = figureBeingEdited {
            println("Presented the menu with origin x: \(frame.origin.x) y: \(frame.origin.x) \n width: \(frame.size.width) height: \(frame.size.height)")
            menuController.setTargetRect(frame, inView: editedFigure)
            menuController.setMenuVisible(true, animated: true)
            menuController.update()
        }
    }
    
    // MARK: - Drawing Methods
    
    /** Draws the Figures that are in the Page */
    private func drawFigures() {
        for i in 0 ..< figures.count {
            let figure = figures[i]
            let figureFrame = CGRectMake(CGFloat(figure.xOrigin.doubleValue), CGFloat(figure.yOrigin.doubleValue), CGFloat(figure.width.doubleValue), CGFloat(figure.height.doubleValue))
            switch (Helper.figureTypeForNumber(figure.type.integerValue)){
            case FigureType.RectType:
                let figureView = FigurePainter.createFigureViewWithFigure(figure, frame: figureFrame, delegate: self)
                pageView.addSubview(figureView)
                figureView.delegate = self
                figureView.index = i
            case FigureType.RoundedType:
                let figureView = FigurePainter.createCircularFigureViewWithFigure(figure, frame: figureFrame, delegate: self)
                pageView.addSubview(figureView)
                figureView.delegate = self
                figureView.index = i
            default:
                break
            }
        }
    }
    
    /** Inserts a Figure into the Page */
    @IBAction func insertFigure(segue: UIStoryboardSegue) {
        if let svc = segue.sourceViewController as? InsertFigureMenuTableViewController {
            if let figure = svc.figureToInsert {
                figure.delegate = self
                figure.index = figures.count - 1
                pageView.addSubview(figure)
            }
        }
    }
    
    // MARK: - Gestures
    
    /**
    Moves a Figure across the Page
    
    :param: panGesture The GestureRecognizer that will indicate where the Figure is
    */
    func moveFigure(panGesture: UIPanGestureRecognizer) {
        let gesturePoint = panGesture.locationInView(self.view)
        if let figure = figureBeingEdited {
            switch (panGesture.state){
            case UIGestureRecognizerState.Began:
                attachmentBehavior = UIAttachmentBehavior(item: figure, attachedToAnchor: gesturePoint)
                attachmentBehavior?.length = 0.0
                dynamicAnimator.addBehavior(attachmentBehavior!)
            case UIGestureRecognizerState.Changed:
                if let attachment = attachmentBehavior {
                    attachment.anchorPoint = gesturePoint
                }
            case UIGestureRecognizerState.Ended:
                if let attachment = attachmentBehavior {
                    dynamicAnimator.removeBehavior(attachment)
                    updateCoordinatesOfFigureWithFigureView(figure)
                }
            default:
                break
            }
        }
    }
    
    /**
    Resizes a Figure
    
    :param: pinchGesture The GestureRecognizer that will indicate the scale to resize the figure
    */
    func pinchFigure(pinchGesture: UIPinchGestureRecognizer) {
        if let figure = figureBeingEdited {
            figure.figurePinched(pinchGesture)
        }
    }
    
    /**
    Registers when the scroll view is touched
    
    :param: tapGesture The GestureRecognizer that will indicate when the scroll view was touched
    */
    func touchedScrollView(tapGesture: UITapGestureRecognizer) {
        colorChooserView?.removeFromSuperview()
        figureBeingEdited?.removeGestureRecognizer(panGestureRecognizer)
        figureBeingEdited?.removeGestureRecognizer(pinchGestureRecognizer)
        figureBeingEdited?.editing = false
        figureBeingEdited = nil
    }
    
    // MARK: - ColorChooser Delegate Methods
    
    func choseColorWithNumber(color: Int, type: ColorChooserType) {
        if let editedFigure = figureBeingEdited {
            let fetchRequest = NSFetchRequest(entityName: ModelConstants.Figure.EntityName)
            fetchRequest.predicate = NSPredicate(format: "\(ModelConstants.Figure.OrderInPage) == %d", editedFigure.index)
            if let figure = page.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)?.first as? Figure {
                if type == .FigureFillColor {
                    figure.fillColor = color
                    editedFigure.fillColor = Helper.figureColorForNumber(color)
                } else if type == .FigureStrokeColor {
                    figure.strokeColor = color
                    editedFigure.strokeColor = Helper.figureColorForNumber(color)
                }
                figure.managedObjectContext?.save(nil)
            }
        }
    }
    
    func changedSliderValue(value: Float, type: ColorChooserType) {
        if let editedFigure = figureBeingEdited {
            let fetchRequest = NSFetchRequest(entityName: ModelConstants.Figure.EntityName)
            fetchRequest.predicate = NSPredicate(format: "\(ModelConstants.Figure.OrderInPage) == %d", editedFigure.index)
            if let figure = page.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)?.first as? Figure {
                if type == .FigureFillColor {
                    figure.alpha = value
                    editedFigure.alpha = CGFloat(value)
                } else if type == .FigureStrokeColor {
                    figure.strokeLineWidth = value 
                    editedFigure.strokeLineWidth = CGFloat(value)
                }
                figure.managedObjectContext?.save(nil)
            }
        }
    }
    
    // MARK: - Figure Update Methods
    
    /** Updates the coordinates of a Figure based on the FigureView that was moved in the Page */
    private func updateCoordinatesOfFigureWithFigureView(figureView: FigureView) {
        if let i = figureView.index {
            let figure = figures[i]
            figure.yOrigin = figureView.frame.origin.y
            figure.xOrigin = figureView.frame.origin.x
        }
    }
    
    // MARK: - FigureView Delegate Methods
    
    func selectedFigureView(figureView: FigureView, editing: Bool) {
        if !editing {
            figureBeingEdited?.removeGestureRecognizer(panGestureRecognizer)
            figureBeingEdited?.removeGestureRecognizer(pinchGestureRecognizer)
            figureBeingEdited = nil
        } else {
            figureBeingEdited = figureView
            figureBeingEdited?.addGestureRecognizer(panGestureRecognizer)
            figureBeingEdited?.addGestureRecognizer(pinchGestureRecognizer)
        }
    }
    
    func doubleTappedFigureView(figureView: FigureView, editingShape: Bool) {
        if !editingShape {
            figureBeingEdited = nil
        } else {
            figureBeingEdited = figureView
        }
    }
    
    func updateFigureViewFrameAndPoints(figureView: FigureView, frame: CGRect, points: [CGPoint]) {
        if let i = figureView.index {
            let updatedFigure = figures[i]
            updatedFigure.width = NSNumber(double: Double(frame.size.width))
            updatedFigure.height = NSNumber(double: Double(frame.size.height))
            updatedFigure.xOrigin = NSNumber(double: Double(frame.origin.x))
            updatedFigure.yOrigin = NSNumber(double: Double(frame.origin.y))
            if let figurePoints = updatedFigure.points.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Point.OrderInFigure, ascending: true, selector: "compare:")]) as? [Point] {
                for k in 0 ..< figurePoints.count {
                    let point = figurePoints[k]
                    point.xOrigin = NSNumber(double: Double(points[k].x))
                    point.yOrigin = NSNumber(double: Double(points[k].y))
                }
            }
        }
    }
    
    func displayMenuControllerForFigureInFrame(figureView: FigureView, frame: CGRect) {
        println("Delegate was called")
        if let figureAlreadyBeingEdited = figureBeingEdited {
            figureAlreadyBeingEdited.removeGestureRecognizer(panGestureRecognizer)
            figureAlreadyBeingEdited.removeGestureRecognizer(pinchGestureRecognizer)
            figureAlreadyBeingEdited.editing = false
            figureAlreadyBeingEdited.editingShape = false
        }
        figureBeingEdited = figureView
        showMenuController(frame)
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
                    dvc.delegate = self
                }
            default:
                break
            }
        }
    }
}
