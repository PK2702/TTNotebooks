//
//  NotebookTableViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/4/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit
import CoreData

class NotebookTableViewController: UITableViewController {

    // MARK : - Variables and Constants
    
    /** The Notebook that will be opened */
    var notebook : Notebook?
    
    /** The sections of the Notebook that is transformed to an Array */
    private var sections : [Section] {
        get {
            if let sects = notebook?.sections.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Section.OrderInNotebook, ascending: true, selector: "compare:")]) as? [Section] {
                return sects
            } else {
                return [Section]()
            }
        }
    }
    
    /** Constants for the Table View */
    private struct tableViewConstants {
        static let cellReuseIdentifier = "Page Cell"
    }
    
    // MARK: - Localized Strings
    
    private struct LStrings {
        static let AddToNotebookAddSectionButton = NSLocalizedString("Add Section", comment: "Action in the action sheet that adds a Section to the Notebook")
        static let AddToNotebookAddNotebookButton = NSLocalizedString("Add Page", comment: "Action in the action sheet that adds a Page to the Notebook")
        static let AddToNotebookCancelButton = NSLocalizedString("Cancel", comment: "Action to cancel the action sheet that adds a section or page to the Notebook")
        static let createPageAlertViewTitle = NSLocalizedString("New Page", comment: "Title of the alert view in which the user will type the name of the page to be created")
        static let createPageAlertViewMessage = NSLocalizedString("Enter the name of the new page", comment: "Message of the alert view in which the user will type the name of the page to be created")
        static let createPageAlertViewCreateButton = NSLocalizedString("Create", comment: "Action that creates a Page with the name given by the user")
        static let createPageAlertViewCancelButton = NSLocalizedString("Cancel", comment: "Action that cancels the alert view in which the user will type the name of the page to be created")
        static let createPageAlertViewTextFiledPlaceholder = NSLocalizedString("Page's Name", comment: "Placeholder in the textfield where the user will type the name of the page to be created")

    }
    
    // MARK: - Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addToNotebook:")
        self.navigationItem.rightBarButtonItems = [addButton, self.editButtonItem()]
    }

    // MARK: - Notebook Actions
    
    /** Function that displays an alert view with Action Sheet style to add a Page or Section to the Notebook */
    func addToNotebook(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(UIAlertAction(title: LStrings.AddToNotebookAddSectionButton, style: UIAlertActionStyle.Default) { (_) -> Void in
            
        })
        actionSheet.addAction(UIAlertAction(title: LStrings.AddToNotebookAddNotebookButton, style: UIAlertActionStyle.Default) { (_) -> Void in
            let createPageAlertView = UIAlertController(title: LStrings.createPageAlertViewTitle, message: LStrings.createPageAlertViewMessage, preferredStyle: UIAlertControllerStyle.Alert)
            createPageAlertView.addTextFieldWithConfigurationHandler{ (textField: UITextField!) -> Void in
                textField.placeholder = LStrings.createPageAlertViewTextFiledPlaceholder
            }
            createPageAlertView.addAction(UIAlertAction(title: LStrings.createPageAlertViewCreateButton, style: UIAlertActionStyle.Default) { (_) -> Void in
                if let textField = createPageAlertView.textFields?.first as? UITextField {
                    self.createPagewithName(textField.text)
                }
            })
            createPageAlertView.addAction(UIAlertAction(title: LStrings.createPageAlertViewCancelButton, style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(createPageAlertView, animated: true, completion: nil)
        })
        actionSheet.addAction(UIAlertAction(title: LStrings.AddToNotebookCancelButton, style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    /**
    Create a Page with a given name and inserts it into the last place of the last section
    
    :param: name The name of the Page that will be created
    */
    private func createPagewithName(name: String) {
        if let context = notebook?.managedObjectContext {
            if let newPage = NSEntityDescription.insertNewObjectForEntityForName(ModelConstants.Page.EntityName, inManagedObjectContext: context) as? Page {
                newPage.name = name
                newPage.creationDate = NSDate()
                newPage.pageLayout = NSNumber(integer: NSUserDefaults.standardUserDefaults().integerForKey(Constants.SettingsVC.PagesDefaultLayoutType))
                newPage.section = sections.last!
                newPage.orderInSection = sections.last!.pages.count
                // WARNING: Must consider case in which empty Notebook in order to create new Section
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table View Actions
    
    /**
    Returns the Page given an Index Path
    
    :param: indexPath The index path that will indicate the section and page number
    :returns: A Page object. If the index path is invalid then the method returns nil
    */
    private func pageForIndexPath (indexPath: NSIndexPath) -> Page? {
        if let pages = sections[indexPath.section].pages.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Page.OrderInSection, ascending: true, selector: "compare:")]) as? [Page] {
            return pages[indexPath.row]
        }
        return nil
    }
    
    /**
    Increases the order in section after a certain point in the Section because of an insertion
    
    :param: indexPath The place from which the order in section will be increased by one
    :param: before The place up until the order in section will be increased by one
    */
    private func increaseOrderInSectionAfterIndexPath (indexPath: NSIndexPath) {
        if let pages = sections[indexPath.section].pages.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Page.OrderInSection, ascending: true, selector: "compare:")]) as? [Page] {
            for  i in indexPath.row ..< pages.count {
                pages[i].orderInSection = pages[i].orderInSection.integerValue + 1
            }
        }
    }
    
    /**
    Increases the order in section after a certain point in the Section
    
    :param: indexPath The place from which the order in section will be increased by one
    :param: before The place up until the order in section will be increased by one
    */
    private func increaseOrderInSectionAfterIndexPath (indexPath: NSIndexPath, before: NSIndexPath) {
        if let pages = sections[indexPath.section].pages.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Page.OrderInSection, ascending: true, selector: "compare:")]) as? [Page] {
            for  i in indexPath.row ..< before.row {
                pages[i].orderInSection = pages[i].orderInSection.integerValue + 1
            }
        }
    }
    
    /**
    Decreases the order in section after a certain point in the Section. This method is used when a cell is deleted in the given index
    
    :param: indexPath The place from which the order in section will be decreased by one. Represents the location of the cell being deleted
    */
    private func decreaseOrderInSectionAfterIndexPath (indexPath: NSIndexPath) {
        if let pages = sections[indexPath.section].pages.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Page.OrderInSection, ascending: true, selector: "compare:")]) as? [Page] {
            for  i in indexPath.row + 1 ..< pages.count {
                pages[i].orderInSection = pages[i].orderInSection.integerValue - 1
            }
        }
    }
    
    /**
    Decreases the order in section after a certain point in the Section and before another one. This method is used when a cell is moved to a given index
    
    :param: indexPath The place from which the order in section will be decreased by one.
    :param: before The place up until the order in section will be decreased  by one
    */
    private func decreaseOrderInSectionAfterIndexPath (indexPath: NSIndexPath, before: NSIndexPath) {
        if let pages = sections[indexPath.section].pages.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Page.OrderInSection, ascending: true, selector: "compare:")]) as? [Page] {
            for  i in indexPath.row + 1 ... before.row {
                pages[i].orderInSection = pages[i].orderInSection.integerValue - 1
            }
        }
    }
    
    /**
    Decreases the order in section after a certain point in the Notebook. This method is used when a sections is deleted at a given index
    
    :param: indexPath The place from which the order in notebook will be decreased by one.
    */
    private func decreaseOrderInNotebookAfterIndexPath (indexPath: NSIndexPath) {
        for  i in indexPath.section + 1 ..< sections.count {
                sections[i].orderInNotebook = sections[i].orderInNotebook.integerValue - 1
        }
    }
    
    /**
    Deletes a Section from the Notebook and updates the order of the other sections
    
    :param: indexPath The place where the Section to be deleted is
    */
    private func deleteSectionInIndexPath (indexPath: NSIndexPath) {
        let sectionToDelete = sections[indexPath.section]
        decreaseOrderInNotebookAfterIndexPath(indexPath)
        notebook?.removeSectionFromSections(sectionToDelete)
        notebook?.managedObjectContext?.deleteObject(sectionToDelete)
        tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].pages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewConstants.cellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell
        if let page = pageForIndexPath(indexPath) {
            cell.detailTextLabel?.text = page.creationDate.description
            cell.textLabel?.text = page.name
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let page = pageForIndexPath(indexPath) {
                decreaseOrderInSectionAfterIndexPath(indexPath)
                sections[indexPath.section].removePageFromPages(page)
                notebook?.managedObjectContext?.deleteObject(page)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                if sections[indexPath.section].pages.count == 0 {
                    deleteSectionInIndexPath(indexPath)
                }
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if let pageToMove = pageForIndexPath(fromIndexPath) {
            if fromIndexPath.section != toIndexPath.section {
                increaseOrderInSectionAfterIndexPath(toIndexPath)
                decreaseOrderInSectionAfterIndexPath(fromIndexPath)
                sections[fromIndexPath.section].removePageFromPages(pageToMove)
                sections[toIndexPath.section].insertPageIntoPages(pageToMove)
                pageToMove.section = sections[toIndexPath.section]
                if sections[fromIndexPath.section].pages.count == 0 {
                    deleteSectionInIndexPath(fromIndexPath)
                }
            } else {
                if fromIndexPath.row > toIndexPath.row {
                    increaseOrderInSectionAfterIndexPath(toIndexPath, before: fromIndexPath)
                } else if fromIndexPath.row < toIndexPath.row{
                    decreaseOrderInSectionAfterIndexPath(fromIndexPath, before: toIndexPath)
                }
            }
            pageToMove.orderInSection = toIndexPath.row
        }
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
