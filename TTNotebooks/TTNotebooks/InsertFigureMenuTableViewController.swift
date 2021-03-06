//
//  InsertFigureMenuTableViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/24/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class InsertFigureMenuTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Localized Strings
    
    /** List of all the Localized Strings of this class */
    private struct LStrings {
        static let PhotoLibraryNotAvailableAlertTitle = NSLocalizedString("Photo Library Unavailable", comment: "Title of the alert that informs the user that the app cannot access the photo library")
        static let PhotoLibraryNotAvailableAlertMessage = NSLocalizedString("Notebooks cannot access the photo library", comment: "Message of the alert that informs the user that the app cannot access the photo library")
        static let CameraNotAvailableAlertTitle = NSLocalizedString("Camera Unavailable", comment: "Title of the alert that informs the user that the app cannot access the device's camera")
        static let CameraNotAvailableAlertMessage = NSLocalizedString("Notebooks cannot access the camera", comment: "Message of the alert that informs the user that the app cannot access the device's camera")
        static let ResourceNotAvailableDismissButtonTitle = NSLocalizedString("Ok", comment: "Name of the button that is used to dismiss the messafe the user gets when one of the media resources is not available")
    }
    
    // MARK: Variables and Constatns
    
    /** Constants for the Table View */
    private struct tableViewConstants {
        static let customInsertFigureCellReuseIdentifier = "Insert Figure Cell"
    }
    
    /** The figure that will be inserted after chosen from this menu */
    var figureToInsert: FigureView?
    
    /** The Page where a new figure will be inserted */
    var page: Page!
    
    /** The delegate that will handle the FigureView */
    var delegate: FigureViewDelegate!
    
    /** The window representing the position of the scroll view in the Page */
    var insertWindow: CGRect!
    
    /** The width of the frame where a normal figure will be drawn */
    let normalFigureWidth: CGFloat = 150.0
    
    /** The width of the frame where a rectangular figure will be drawn */
    let rectangularFigureWidth: CGFloat = 225.0
    
    /** The height of the frame where a normal figure will be dran */
    let normalFigureHeight: CGFloat = 150.0
    
    /** The controller in charge of taking or picking the photos and videos from the camera roll */
    var imagePicker: UIImagePickerController?
    
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
            performSegueWithIdentifier(SegueIdentifiers.InsertFigureUnwindSegue, sender: self)
        case InsertFigureType.RectangleFigure:
            figureToInsert = createRectangleFigureWithFrame(rectangularFrameToDrawFigure)
            performSegueWithIdentifier(SegueIdentifiers.InsertFigureUnwindSegue, sender: self)
        case InsertFigureType.RhombusFigure:
            figureToInsert = createRhombusFigureWithFrame(rectangularFrameToDrawFigure)
            performSegueWithIdentifier(SegueIdentifiers.InsertFigureUnwindSegue, sender: self)
        case InsertFigureType.TriangleFigure:
            figureToInsert = createTriangleFigureWithFrame(frameToDrawFigure)
            performSegueWithIdentifier(SegueIdentifiers.InsertFigureUnwindSegue, sender: self)
        case InsertFigureType.CircleFigure:
            figureToInsert = createOvaleFigureWithFrame(frameToDrawFigure)
            performSegueWithIdentifier(SegueIdentifiers.InsertFigureUnwindSegue, sender: self)
        case InsertFigureType.OvalFigure:
            figureToInsert = createOvaleFigureWithFrame(rectangularFrameToDrawFigure)
            performSegueWithIdentifier(SegueIdentifiers.InsertFigureUnwindSegue, sender: self)
        case InsertFigureType.ImageFigure:
            createUIImagePickerControllerForImageLibrary()
        case InsertFigureType.PhotoFigure:
            createUIImagePickerControllerForPhoto()
        default:
            figureToInsert = nil
        }
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
            newFigure.width = NSNumber(double: Double(frame.width))
            newFigure.height = NSNumber(double: Double(frame.height))
            newFigure.fillColor = NSNumber(integer: userDefaults.integerForKey(Constants.SettingsVC.FigureDefaultColor))
            newFigure.strokeColor = NSNumber(integer: userDefaults.integerForKey(Constants.SettingsVC.StrokeDefaultColor))
            newFigure.strokeLineWidth = NSNumber(double: Helper.strokeLineWidthForNumber(Int(userDefaults.doubleForKey(Constants.SettingsVC.FigureDefaultLineWidth))))
            newFigure.type = NSNumber(integer: Helper.numberForFigureType(type))
            newFigure.xOrigin = NSNumber(double: Double(frame.origin.x))
            newFigure.yOrigin = NSNumber(double: Double(frame.origin.y))
            newFigure.orderInPage = NSNumber(integer: page.figures.count)
            newFigure.page = page
            newFigure.insertPointsIntoFigure(points)
            newFigure.alpha = 1.0
            return newFigure
        }
        return nil
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
                return FigurePainter.createFigureViewWithFigure(figure, frame: frame, delegate: delegate)
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
                return FigurePainter.createFigureViewWithFigure(figure, frame: frame, delegate: delegate)
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
                return FigurePainter.createFigureViewWithFigure(figure, frame: frame, delegate: delegate)
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
            return FigurePainter.createCircularFigureViewWithFigure(figure, frame: frame, delegate: delegate)
        }
        return nil
    }
    
    /** Calls a UIImagePickerController to get an image form the Image Library */
    private func createUIImagePickerControllerForImageLibrary() {
        if  !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let alertController = UIAlertController(title: LStrings.PhotoLibraryNotAvailableAlertTitle, message: LStrings.PhotoLibraryNotAvailableAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: LStrings.ResourceNotAvailableDismissButtonTitle, style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            imagePicker = NotebooksUIImagePickerController()
            imagePicker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker?.mediaTypes = [kUTTypeImage]
            imagePicker?.allowsEditing = true
            imagePicker?.delegate = self
            self.presentViewController(imagePicker!, animated: true, completion: nil)
        }
    }
    
    /** Calls a UIImagePickerController to take a photo or video */
    private func createUIImagePickerControllerForPhoto() {
        if  !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let alertController = UIAlertController(title: LStrings.CameraNotAvailableAlertTitle, message: LStrings.CameraNotAvailableAlertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: LStrings.ResourceNotAvailableDismissButtonTitle, style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            imagePicker = UIImagePickerController()
            imagePicker?.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker?.mediaTypes = [kUTTypeImage]
            imagePicker?.allowsEditing = true
            imagePicker?.delegate = self
            self.presentViewController(imagePicker!, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerController Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        if let url = createUniquePathFileURLInDocuments() {
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            imageData.writeToURL(url, atomically: true)
            let imageWidth = self.rectangularFigureWidth
            let imageHeight = self.rectangularFigureWidth * image.size.height / image.size.width
            let imageFrame = CGRectMake(self.insertWindow.midX - imageWidth / 2, self.insertWindow.midY - imageHeight / 2, imageWidth, imageHeight)
            if let figure = createFigureWithPoints([Point](), type: FigureType.ImageType, frame: imageFrame) {
                figure.fileURL = url.absoluteString!
                figureToInsert = FigurePainter.createImageFigureViewWithFigure(figure, frame: imageFrame, delegate: delegate)
                presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                performSegueWithIdentifier(SegueIdentifiers.InsertFigureUnwindSegue, sender: self)
            }
        }
    }
    
    // MARK: - Helper With Directories
    
    /** Creates a unique URL Path in the Documents directory to save a file */
    func createUniquePathFileURLInDocuments() -> NSURL? {
        let directories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        if var url = directories.first as? NSURL {
            let uniqueNumber = "\(floor(NSDate.timeIntervalSinceReferenceDate()))"
            url = url.URLByAppendingPathComponent(uniqueNumber)
            return url;
        }
        return nil;
    }
    
}
