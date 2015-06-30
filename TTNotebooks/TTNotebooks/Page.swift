//
//  Page.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 6/8/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

class Page: NSManagedObject {

    @NSManaged var creationDate: NSDate
    @NSManaged var name: String
    @NSManaged var orderInSection: NSNumber
    @NSManaged var pageLayout: NSNumber
    @NSManaged var figures: NSSet
    @NSManaged var section: Section

}
