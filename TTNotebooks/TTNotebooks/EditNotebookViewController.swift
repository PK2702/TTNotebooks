//
//  EditNotebookViewController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 4/26/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class EditNotebookViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var notebookNameTxtField: UITextField!
    
    var notebook: Notebook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notebookNameTxtField.text = notebook.name
        pickerView.selectRow(notebook.color.integerValue, inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Helper.numberOfNotebookColors
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Helper.notebookColorNameForNumber(row)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func cancelEditting(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func makeChangesEffective(sender: AnyObject) {
        notebook.name = notebookNameTxtField.text
        notebook.color = pickerView.selectedRowInComponent(0) == 0 ?  NSNumber(unsignedInt: arc4random_uniform(4)) : NSNumber(unsignedInteger: pickerView.selectedRowInComponent(0))
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
