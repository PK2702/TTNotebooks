//
//  NotebooksViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 3/21/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit
import CoreData

class NotebooksViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties and outlets
/*
    The collection view that will display all the outlets
*/
    @IBOutlet weak var notebooksCollectionView: UICollectionView! {
        didSet {
            notebooksCollectionView.delegate = self
            notebooksCollectionView.dataSource = self
        }
    }
    
    var context: NSManagedObjectContext? {
        didSet{
            self.updateNotebooks()
            self.notebooksCollectionView?.reloadData()
        }
    }
    
    var notebooks = [Notebook]()
    
    // MARK: - Constants
    
    let NotebookCellIdentifier = "Notebook Cell"
    let NotebookWidth :CGFloat = 160.0
    let NotebookHeight :CGFloat = 200.0
    let NotebookEdges :CGFloat = 20
    
    // MARK: - Application Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserverForName("Document saved", object: nil, queue: nil) { (note: NSNotification!) -> Void in
            if let uInf = note.userInfo {
                if let cntxt = uInf["contexto"] as? NSManagedObjectContext {
                    self.context = cntxt
                }
            }
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "Document saved", object: nil)
    }
    
    func updateNotebooks() {
        let request = NSFetchRequest(entityName: "Notebook")
        request.predicate = nil
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector: "localizedCompare:")]
        notebooks = context?.executeFetchRequest(request, error: nil) as [Notebook]
    }
    
    func createNewNotebook(name: String) {
        let newNotebook = NSEntityDescription.insertNewObjectForEntityForName("Notebook", inManagedObjectContext: context!) as Notebook
        newNotebook.name = name
        notebooks.append(newNotebook)
        notebooksCollectionView.reloadData()
    }
    
    @IBAction func createNotebook(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Notebook", message: "What will be the name of your new Notebook", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "Name of the Notebook"
        }
        alert.addAction( UIAlertAction(title: "Create", style: UIAlertActionStyle.Default) { (_) -> Void in
            if let textField = alert.textFields?.first as? UITextField {
                self.createNewNotebook(textField.text)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)

    }
    
    
    // MARK: - UICollectionView Delegate Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notebooks.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NotebookCellIdentifier, forIndexPath: indexPath) as NotebookCollectionViewCell
        let notebook = self.notebooks[indexPath.row]
        cell.notebook = notebook
        cell.name = notebook.name
        cell.backgroundColor = randomColor()
        return cell
    }
    
    func randomColor() -> UIColor  {
        let rdn = arc4random_uniform(4)
        switch (rdn) {
        case 1:
            return UIColor.whiteColor()
        case 2:
            return UIColor.greenColor()
        case 3:
            return UIColor.yellowColor()
        default:
            return UIColor.redColor()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = min(NotebookWidth, view.bounds.width/3 - NotebookEdges*2)
        let height = NotebookHeight / NotebookWidth * width
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = notebooksCollectionView.cellForItemAtIndexPath(indexPath) as NotebookCollectionViewCell
        println(cell.name)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, NotebookEdges, 8, NotebookEdges)
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
