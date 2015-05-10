//
//  Notebook+Collection.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/9/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation

extension Notebook {
    
    /**
    Method used to remove a Section from the sections set of the Notebook
    
    :param: section The Section to be removed from the Notebook and deleted from the context
    */
    func removeSectionFromSections(section: Section) {
        let mutableSections = NSMutableSet(set: sections)
        mutableSections.removeObject(section)
        managedObjectContext?.deleteObject(section)
        sections = mutableSections
    }
    
    /**
    Method used to insert a Sectino into the sections set of the Notebook
    
    :param: section The Section that will be inserted into the Notebook
    */
    func insertSectionIntoSections(section: Section) {
        let mutableSections = NSMutableSet(set: sections)
        mutableSections.addObject(section)
        sections = mutableSections
    }
    
}