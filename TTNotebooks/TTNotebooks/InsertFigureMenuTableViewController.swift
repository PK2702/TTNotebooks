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
    
    /** The heigh of the frame where a normal figure will be dran */
    let normalFigureHeight: CGFloat = 100.0
    
    /** The frame where the Figure will be drawn */
    lazy var frameToDrawFigure: CGRect = CGRectMake(self.insertWindow.midX - self.normalFigureWidth/2,
        self.insertWindow.midY - self.normalFigureHeight/2, self.normalFigureWidth, self.normalFigureHeight)
    
    // MARK: Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            figureToInsert = createSquareFigure()
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
    private func createFigureWithPoints(points: [Point], type: FigureType) -> Figure?{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let newFigure = NSEntityDescription.insertNewObjectForEntityForName(ModelConstants.Figure.EntityName, inManagedObjectContext: page.managedObjectContext!) as? Figure{
            newFigure.width = NSNumber(double: Double(normalFigureWidth))
            newFigure.height = NSNumber(double: Double(normalFigureHeight))
            newFigure.fillColor = NSNumber(integer: userDefaults.integerForKey(Constants.SettingsVC.FigureDefaultColor))
            newFigure.strokeColor = NSNumber(integer: userDefaults.integerForKey(Constants.SettingsVC.StrokeDefaultColor))
            newFigure.strokeLineWidth = NSNumber(double: userDefaults.doubleForKey(Constants.SettingsVC.FigureDefaultLineWidth))
            newFigure.type = NSNumber(integer: Helper.numberForFigureType(type))
            newFigure.xOrigin = NSNumber(double: Double(frameToDrawFigure.origin.x))
            newFigure.yOrigin = NSNumber(double: Double(frameToDrawFigure.origin.y))
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
    private func createFigureViewWithFigure(figure: Figure) -> FigureView{
        let points = figure.points.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Point.OrderInFigure, ascending: true, selector: "compare:")]) as! [Point]
        var coordinates = [CGPoint]()
        for point in points {
            coordinates.append(point.cGPointForCoordinates())
        }
        let fillColor = Helper.figureColorForNumber(figure.fillColor.integerValue)
        let strokeColor = Helper.figureColorForNumber(figure.strokeColor.integerValue)
        let strokeLineWidth = CGFloat(Helper.strokeLineWidthForNumber(figure.strokeLineWidth.integerValue))
        return FigureView(frame: frameToDrawFigure, points: coordinates, fillColor: fillColor, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth)
    }
    
    /**
    Creates a CircularFigureView based on a Figure object
    
    :param: figure The Figure that will be used to create the view
    :returns: A CircularFigureView created with the Figure
    */
    private func createCircularFigureViewWithFigure(figure: Figure) -> FigureView{
        var coordinates = [CGPoint]()
        let fillColor = Helper.figureColorForNumber(figure.fillColor.integerValue)
        let strokeColor = Helper.figureColorForNumber(figure.strokeColor.integerValue)
        let strokeLineWidth = CGFloat(Helper.strokeLineWidthForNumber(figure.strokeLineWidth.integerValue))
        return FigureView(frame: frameToDrawFigure, points: coordinates, fillColor: fillColor, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth)
    }
    
    /**
    Creates a Figure in the form of a Square also creates the NSManagedObject and inserts it into the Page
    
    :returns: A FigureView in the form of a Square
    */
    private func createSquareFigure() -> FigureView?{
        let point1 = Point.createPointWithCoordinates(0.0, y: 0.0, order: 0, context: page.managedObjectContext!)
        let point2 = Point.createPointWithCoordinates(Double(0.0), y: Double(frameToDrawFigure.maxY), order: 1, context: page.managedObjectContext!)
        let point3 = Point.createPointWithCoordinates(Double(frameToDrawFigure.maxX), y: Double(frameToDrawFigure.maxY), order: 2, context: page.managedObjectContext!)
        let point4 = Point.createPointWithCoordinates(Double(frameToDrawFigure.maxX), y: Double(0.0), order: 3, context: page.managedObjectContext!)
        if let p1 = point1, p2 = point2, p3 = point3, p4 = point4 {
            if let figure = createFigureWithPoints([p1,p2,p3,p4], type: FigureType.RectType) {
                println("Created square figure")
                return createFigureViewWithFigure(figure)
            }
        }
        return nil
    }
}
