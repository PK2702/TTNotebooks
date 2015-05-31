//
//  Page+Collection.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/30/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation

extension Page {
    
    /**
    Removes a Figure from the figures set of a Page
    
    :param: figure The figure that is going to be removed from the Page
    */
    func removeFigureFromPage(figure: Figure) {
        let mutableFigures = NSMutableSet(set: figures)
        mutableFigures.removeObject(figure)
        figures = mutableFigures
    }
    
    /**
    Inserts a Figure into the figures set of a Page
    
    :param: figure The figure that is going to be inserted in the Page
    */
    func insertFigureIntoPage(figure: Figure) {
        let mutableFigures = NSMutableSet(set: figures)
        mutableFigures.addObject(figure)
        figures = mutableFigures
    }
    
}