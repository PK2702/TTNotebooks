//
//  Point.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/24/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

class Point: NSManagedObject {

    @NSManaged var xOrigin: NSNumber
    @NSManaged var yOrigin: NSNumber
    @NSManaged var orderInFigure: NSNumber
    @NSManaged var figure: Figure

}
