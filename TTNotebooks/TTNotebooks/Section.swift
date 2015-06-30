//
//  Section.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 6/8/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

class Section: NSManagedObject {

    @NSManaged var creationDate: NSDate
    @NSManaged var name: String
    @NSManaged var orderInNotebook: NSNumber
    @NSManaged var notebook: Notebook
    @NSManaged var pages: NSSet

}
