//
//  Figure.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 8/22/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

class Figure: NSManagedObject {

    @NSManaged var alpha: NSNumber
    @NSManaged var fileURL: String
    @NSManaged var fillColor: NSNumber
    @NSManaged var height: NSNumber
    @NSManaged var orderInPage: NSNumber
    @NSManaged var strokeColor: NSNumber
    @NSManaged var strokeLineWidth: NSNumber
    @NSManaged var type: NSNumber
    @NSManaged var width: NSNumber
    @NSManaged var xOrigin: NSNumber
    @NSManaged var yOrigin: NSNumber
    @NSManaged var page: Page
    @NSManaged var points: NSSet

}
