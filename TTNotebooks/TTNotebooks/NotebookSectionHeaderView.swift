//
//  NotebookSectionHeaderView.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/19/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class NotebookSectionHeaderView: UIView, UITextFieldDelegate {
    
    // MARK: - Variables and Constants
    
    /** Object that will act as the data source for the section header */
    var datasource: NotebookHeaderDataSource
    
    /** Order of the Section in the Notebook */
    var section: Int
    
    /** Name of the Section in the Notebook */
    var sectionName: String
    
    /** Textfield in which the name of the Section is displayed */
    var nameTextfield: UITextField?
    
    /** Button that will be pressed when the user wants to delete the entire Section */
    var deleteButton: UIButton?
    
    /** Fraction of the superview's width that the Textfield will occupy */
    private let sectionNameFractionOfFrameWidth: CGFloat = 4/5
    
    /** Variable that will indicate if the section header is being edited */
    var editing: Bool {
        didSet {
            deleteButton?.hidden = !editing
            nameTextfield?.enabled = editing
            if editing == false {
                endedEditingSectionName()
            }
        }
    }
    
    // MARK: - Initializers
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
    Initializes the Seciton Header View with a frame, a data source, section index and name
    
    :param: frame The frame in which the view will be encased
    :param: datasource The data source of this view that implements the protocol NotebookHeaderDataSource
    :param: section The index of the Section in the Notebook
    :param: sectionName The name of the Section
    */
    init(frame: CGRect, datasource: NotebookHeaderDataSource, section: Int, sectionName: String, editing: Bool) {
        self.datasource = datasource
        self.section = section
        self.sectionName = sectionName
        self.editing = editing
        super.init(frame: frame)
        self.nameTextfield = giveTextfieldWithName(sectionName, frame: frame)
        self.deleteButton = giveDeleteButtonWithFrame(frame)
        if let txtField = nameTextfield {
            self.addSubview(txtField)
        }
        if let deltButton = deleteButton {
            self.addSubview(deltButton)
        }
    }
    
    override func awakeFromNib() {
        self.opaque = false
        self.contentMode = UIViewContentMode.Redraw
        self.backgroundColor = nil
    }
    
    // MARK: - Subviews Creation
    
    /**
    Returns a Textfield in which the name of the section will be displayed
    
    :param: name The name of the Section
    :param: frame The frame of the Section Header
    :returns: A UITextField with the specifics necessary to appear as a section title
    */
    private func giveTextfieldWithName(name: String, frame: CGRect) -> UITextField {
        let textfield = UITextField(frame: CGRectMake(frame.origin.x + 8, frame.origin.y + 8, frame.size.width * sectionNameFractionOfFrameWidth - 8, frame.size.height - 16))
        textfield.text = sectionName
        textfield.textColor = UIColor.lightGrayColor()
        textfield.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        textfield.borderStyle = UITextBorderStyle.None
        textfield.delegate = self
        textfield.enabled = editing
        return textfield
    }
    
    /**
    Returns a Button with which the user can delete the Section that this header view represents
    
    :param: frame The frame of the Section Header
    :returns: A UIButton that registers the delete action
    */
    private func giveDeleteButtonWithFrame(frame: CGRect) ->UIButton? {
        let buttonWidth  = (1.0 - sectionNameFractionOfFrameWidth) * frame.width
        if let button = UIButton.buttonWithType(UIButtonType.System) as? UIButton {
            button.frame = CGRectMake(frame.width - buttonWidth + 8, frame.origin.y + 8, buttonWidth - 16, frame.size.height - 16)
            button.setTitle("Delete", forState: UIControlState.Normal)
            button.addTarget(self, action: "deleteSectionHeader:", forControlEvents: UIControlEvents.TouchUpInside)
            button.hidden = !editing
            return button
        }
        return nil
    }
    
    // MARK: - Actions
    
    /** Method that will be called when the delete button is pressed */
    func deleteSectionHeader(sender: UIButton) {
        datasource.deleteSectionAtIndex(section)
    }
    
    /** Method that will be called when the user ends editting the name textfield */
    func endedEditingSectionName() {
        if let txtField = nameTextfield {
            datasource.changedTextAtSectionTitle(txtField.text, section: section)
        }
    }
    
    // MARK: - Textfield Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        endedEditingSectionName()
        return true
    }
}
