//
//  Point+Creation.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/30/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

extension Point{
    
    /**
    Creates a Point with the given params
    
    :param: x The x coordinate of the point
    :param: y The y coordinate of the point
    :param: order The order of the Point that will be used to draw the Figure
    :param: context The context where the point will be added
    :returns: A Point object to insert in a Figure
    */
    class func createPointWithCoordinates(x: Double, y: Double, order: Int, context: NSManagedObjectContext) -> Point?{
        if let newPoint = NSEntityDescription.insertNewObjectForEntityForName(ModelConstants.Point.EntityName, inManagedObjectContext: context) as? Point {
            newPoint.xOrigin = NSNumber(double: x)
            newPoint.yOrigin = NSNumber(double: y)
            newPoint.orderInFigure = order
            return newPoint
        }
        return nil
    }
}