//
//  Point.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 6/8/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

class Point: NSManagedObject {

    @NSManaged var orderInFigure: NSNumber
    @NSManaged var xOrigin: NSNumber
    @NSManaged var yOrigin: NSNumber
    @NSManaged var figure: Figure

}
