//
//  NotebookHeaderDataSource.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/18/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation

protocol NotebookHeaderDataSource {
    
    /**
    Method that is called when the delete button is pressed at the section
    
    :param: index The index of the Section that is going to be deleted
    */
    func deleteSectionAtIndex(index: Int)
    
    /**
    Method that is called when the title of a section is changed
    
    :param: title The new name of the Section
    */
    func changedTextAtSectionTitle(title: String, section:Int)
}
