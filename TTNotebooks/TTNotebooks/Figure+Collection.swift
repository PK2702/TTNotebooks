//
//  Figure+Collection.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/30/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation

extension Figure {
    
    /**
    Inserts an array of Points into the points set of a Figure
    
    :param: points The array of points that is going to be inserted in the Figure
    */
    func insertPointsIntoFigure(newPoints: [Point]) {
        let mutablePoints = NSMutableSet(set: points)
        mutablePoints.addObjectsFromArray(newPoints)
        points = mutablePoints
    }
}