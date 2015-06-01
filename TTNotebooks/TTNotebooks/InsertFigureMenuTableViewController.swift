//
//  InsertFigureMenuTableViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/24/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit
import CoreData

class InsertFigureMenuTableViewController: UITableViewController {

    // MARK: Variables and Constatns
    
    /** Constants for the Table View */
    private struct tableViewConstants {
        static let customInsertFigureCellReuseIdentifier = "Insert Figure Cell"
    }
    
    /** The figure that will be inserted after chosen from this menu */
    var figureToInsert: FigureView?
    
    /** The Page where a new figure will be inserted */
    var page: Page!
    
    /** The window representing the position of the scroll view in the Page */
    var insertWindow: CGRect!
    
    /** The width of the frame where a normal figure will be drawn */
    let normalFigureWidth: CGFloat = 100.0
    
    /** The width of the frame where a rectangular figure will be drawn */
    let rectangularFigureWidth: CGFloat = 150.0
    
    /** The heigh of the frame where a normal figure will be dran */
    let normalFigureHeight: CGFloat = 100.0
    
    /** The frame where a Figure in a square will be drawn */
    lazy var frameToDrawFigure: CGRect = CGRectMake(self.insertWindow.midX - self.normalFigureWidth/2,
        self.insertWindow.midY - self.normalFigureHeight/2, self.normalFigureWidth, self.normalFigureHeight)
    
    /** The frame where a Figure in a rectangle will be drawn */
    lazy var rectangularFrameToDrawFigure: CGRect = CGRectMake(self.insertWindow.midX - self.rectangularFigureWidth/2,
        self.insertWindow.midY - self.normalFigureHeight/2, self.rectangularFigureWidth, self.normalFigureHeight)
    
    // MARK: Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .Popover
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel:")
        self.navigationItem.leftBarButtonItem = cancelButton
        println("Insert window has origin: \(insertWindow.origin.x), \(insertWindow.origin.y) \n width:\(insertWindow.size.width) \n width:\(insertWindow.size.height)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return InsertFigureMenuHelper.numberOfSections()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return InsertFigureMenuHelper.nameForSection(section)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InsertFigureMenuHelper.numberOfRowsForSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewConstants.customInsertFigureCellReuseIdentifier, forIndexPath: indexPath) as! InsertFigureTableViewCell
        cell.figureName.text = InsertFigureMenuHelper.nameOfFigureForSection(indexPath.section, row: indexPath.row)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let figureType = InsertFigureMenuHelper.figureTypeForSection(indexPath.section, row: indexPath.row)
        switch (figureType) {
        case InsertFigureType.SquareFigure:
            figureToInsert = createRectangleFigureWithFrame(frameToDrawFigure)
        case InsertFigureType.RectangleFigure:
            figureToInsert = createRectangleFigureWithFrame(rectangularFrameToDrawFigure)
        case InsertFigureType.RhombusFigure:
            figureToInsert = createRhombusFigureWithFrame(rectangularFrameToDrawFigure)
        case InsertFigureType.TriangleFigure:
            figureToInsert = createTriangleFigureWithFrame(frameToDrawFigure)
        case InsertFigureType.CircleFigure:
            figureToInsert = createOvaleFigureWithFrame(frameToDrawFigure)
        case InsertFigureType.OvalFigure:
            figureToInsert = createOvaleFigureWithFrame(rectangularFrameToDrawFigure)
        default:
            figureToInsert = nil
        }
        performSegueWithIdentifier(SegueIdentifiers.InsertFigureUnwindSegue, sender: self)
    }
    
    // MARK: - Navigation
    
    private  struct SegueIdentifiers {
        static let InsertFigureUnwindSegue = "Do Add Figure"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch (identifier) {
            case SegueIdentifiers.InsertFigureUnwindSegue:
                if figureToInsert == nil {
                    println("This shit is nil")
                }
                dismissViewControllerAnimated(true, completion: nil)
            default:
                break
            }
        }
    }
    
    // MARK: - Figure Creation Methods
    
    /**
    Creates a Figure with points and a certain type
    
    :param: points An array of Points that compose the edges of the Figure
    :param: type The type of the Figure
    :returns: A Figure object
    */
    private func createFigureWithPoints(points: [Point], type: FigureType, frame: CGRect) -> Figure?{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let newFigure = NSEntityDescription.insertNewObjectForEntityForName(ModelConstants.Figure.EntityName, inManagedObjectContext: page.managedObjectContext!) as? Figure{
            newFigure.width = NSNumber(double: Double(normalFigureWidth))
            newFigure.height = NSNumber(double: Double(normalFigureHeight))
            newFigure.fillColor = NSNumber(integer: userDefaults.integerForKey(Constants.SettingsVC.FigureDefaultColor))
            newFigure.strokeColor = NSNumber(integer: userDefaults.integerForKey(Constants.SettingsVC.StrokeDefaultColor))
            newFigure.strokeLineWidth = NSNumber(double: userDefaults.doubleForKey(Constants.SettingsVC.FigureDefaultLineWidth))
            newFigure.type = NSNumber(integer: Helper.numberForFigureType(type))
            newFigure.xOrigin = NSNumber(double: Double(frame.origin.x))
            newFigure.yOrigin = NSNumber(double: Double(frame.origin.y))
            newFigure.page = page
            newFigure.insertPointsIntoFigure(points)
            return newFigure
        }
        return nil
    }
    
    /**
    Creates a FigureView based on a Figure object
    
    :param: figure The Figure that will be used to create the view
    :returns: A FigureView created with the Figure
    */
    private func createFigureViewWithFigure(figure: Figure, frame: CGRect) -> FigureView{
        let points = figure.points.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Point.OrderInFigure, ascending: true, selector: "compare:")]) as! [Point]
        var coordinates = [CGPoint]()
        for point in points {
            coordinates.append(point.cGPointForCoordinates())
        }
        let fillColor = Helper.figureColorForNumber(figure.fillColor.integerValue)
        let strokeColor = Helper.figureColorForNumber(figure.strokeColor.integerValue)
        let strokeLineWidth = CGFloat(Helper.strokeLineWidthForNumber(figure.strokeLineWidth.integerValue))
        return FigureView(frame: frame, points: coordinates, fillColor: fillColor, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth)
    }
    
    /**
    Creates a CircularFigureView based on a Figure object
    
    :param: figure The Figure that will be used to create the view
    :returns: A CiruclarFigureView created with the Figure
    */
    private func createCircularFigureViewWithFigure(figure: Figure, frame: CGRect) -> CircularFigureView{
        var coordinates = [CGPoint]()
        let fillColor = Helper.figureColorForNumber(figure.fillColor.integerValue)
        let strokeColor = Helper.figureColorForNumber(figure.strokeColor.integerValue)
        let strokeLineWidth = CGFloat(Helper.strokeLineWidthForNumber(figure.strokeLineWidth.integerValue))
        return CircularFigureView(frame: frame, points: coordinates, fillColor: fillColor, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth)
    }
    
    /**
    Creates a Figure in the form of a Rectangle also creates the NSManagedObject and inserts it into the Page
    
    :param: frame The frame in which the Figure will be drawn
    :returns: A FigureView in the form of a Rectangle
    */
    private func createRectangleFigureWithFrame(frame: CGRect) -> FigureView?{
        let point1 = Point.createPointWithCoordinates(0.0, y: 0.0, order: 0, context: page.managedObjectContext!)
        let point2 = Point.createPointWithCoordinates(Double(0.0), y: Double(frame.size.height), order: 1, context: page.managedObjectContext!)
        let point3 = Point.createPointWithCoordinates(Double(frame.size.width), y: Double(frame.size.height), order: 2, context: page.managedObjectContext!)
        let point4 = Point.createPointWithCoordinates(Double(frame.size.width), y: Double(0.0), order: 3, context: page.managedObjectContext!)
        if let p1 = point1, p2 = point2, p3 = point3, p4 = point4 {
            if let figure = createFigureWithPoints([p1,p2,p3,p4], type: FigureType.RectType, frame: frame) {
                println("Created square figure")
                return createFigureViewWithFigure(figure, frame: frame)
            }
        }
        return nil
    }
    
    let rhombusOffset: CGFloat = 0.25
    
    /**
    Creates a Figure in the form of a Rhombus also creates the NSManagedObject and inserts it into the Page
    
    :param: frame The frame in which the Figure will be drawn
    :returns: A FigureView in the form of a Rhombus
    */
    private func createRhombusFigureWithFrame(frame: CGRect) -> FigureView?{
        let point1 = Point.createPointWithCoordinates(Double(frame.size.width * rhombusOffset), y: 0.0, order: 0, context: page.managedObjectContext!)
        let point2 = Point.createPointWithCoordinates(0.0, y: Double(frame.size.height), order: 1, context: page.managedObjectContext!)
        let point3 = Point.createPointWithCoordinates(Double(frame.size.width * (1.0 - rhombusOffset)), y: Double(frame.size.height), order: 2, context: page.managedObjectContext!)
        let point4 = Point.createPointWithCoordinates(Double(frame.size.width), y: Double(0.0), order: 3, context: page.managedObjectContext!)
        if let p1 = point1, p2 = point2, p3 = point3, p4 = point4 {
            if let figure = createFigureWithPoints([p1,p2,p3,p4], type: FigureType.RectType, frame: frame) {
                println("Created rhombus figure")
                return createFigureViewWithFigure(figure, frame: frame)
            }
        }
        return nil
    }
    
    /**
    Creates a Figure in the form of a Triangle also creates the NSManagedObject and inserts it into the Page
    
    :param: frame The frame in which the Figure will be drawn
    :returns: A FigureView in the form of a Triangle
    */
    private func createTriangleFigureWithFrame(frame: CGRect) -> FigureView?{
        let point1 = Point.createPointWithCoordinates(Double(frame.size.width / 2), y: 0.0, order: 0, context: page.managedObjectContext!)
        let point2 = Point.createPointWithCoordinates(Double(0.0), y: Double(frame.size.height), order: 1, context: page.managedObjectContext!)
        let point3 = Point.createPointWithCoordinates(Double(frame.size.width), y: Double(frame.size.height), order: 2, context: page.managedObjectContext!)
        if let p1 = point1, p2 = point2, p3 = point3{
            if let figure = createFigureWithPoints([p1,p2,p3], type: FigureType.RectType, frame: frame) {
                println("Created triangle figure")
                return createFigureViewWithFigure(figure, frame: frame)
            }
        }
        return nil
    }
    
    /**
    Creates a Figure in the form of an Oval also creates the NSManagedObject and inserts it into the Page
    
    :param: frame The frame in which the Figure will be drawn
    :returns: A CircularFigureView in the form of a Rectangle
    */
    private func createOvaleFigureWithFrame(frame: CGRect) -> CircularFigureView?{
        if let figure = createFigureWithPoints([Point](), type: FigureType.RoundedType, frame: frame) {
            println("Created square figure")
            return createCircularFigureViewWithFigure(figure, frame: frame)
        }
        return nil
    }

}
