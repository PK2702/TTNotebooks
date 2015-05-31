//
//  Page.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/24/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

class Page: NSManagedObject {

    @NSManaged var creationDate: NSDate
    @NSManaged var name: String
    @NSManaged var orderInSection: NSNumber
    @NSManaged var pageLayout: NSNumber
    @NSManaged var section: Section
    @NSManaged var figures: NSSet

}
