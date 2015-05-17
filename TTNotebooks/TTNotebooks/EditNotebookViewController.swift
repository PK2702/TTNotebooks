//
//  EditNotebookViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 4/26/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class EditNotebookViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - Properties and outlets
    
    /** Picker view that shows the lists of colors for the Notebook */
    @IBOutlet weak var pickerView: UIPickerView!
    
    /** Label that displays the name of the Notebook */
    @IBOutlet weak var notebookNameTxtField: UITextField!
    
    /** Notebook that is being edited */
    var notebook: Notebook!
    
    // MARK: - Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notebookNameTxtField.text = notebook.name
        pickerView.selectRow(notebook.color.integerValue, inComponent: 0, animated: true)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "makeChangesEffective:")
        self.navigationItem.rightBarButtonItem = doneButton
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelEditing:")
        self.navigationItem.leftBarButtonItem = cancelButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PickerView delegate and data source
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Helper.numberOfNotebookColors
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Helper.notebookColorNameForNumber(row)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: - Actions
    
    /** Cancel the editing of the Notebook */
    func cancelEditing(sender: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /** Commit the changes done to the Notebook */
    func makeChangesEffective(sender: UIButton) {
        notebook.name = notebookNameTxtField.text
        notebook.color = pickerView.selectedRowInComponent(0) == 0 ?  NSNumber(unsignedInt: arc4random_uniform(4)) : NSNumber(unsignedInteger: pickerView.selectedRowInComponent(0))
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }    
}
