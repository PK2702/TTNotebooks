//
//  Figure.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 6/8/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

class Figure: NSManagedObject {

    @NSManaged var fillColor: NSNumber
    @NSManaged var height: NSNumber
    @NSManaged var strokeColor: NSNumber
    @NSManaged var strokeLineWidth: NSNumber
    @NSManaged var type: NSNumber
    @NSManaged var width: NSNumber
    @NSManaged var xOrigin: NSNumber
    @NSManaged var yOrigin: NSNumber
    @NSManaged var orderInPage: NSNumber
    @NSManaged var page: Page
    @NSManaged var points: NSSet

}
