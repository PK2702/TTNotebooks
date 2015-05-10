//
//  Section+Collection.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/9/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation


extension Section {
    
    /**
    Removes a Page from the pages set of a Section
    
    :param: page The page that is going to be removed from the Section
    */
    func removePageFromPages(page: Page) {
        let mutablePages = NSMutableSet(set: pages)
        mutablePages.removeObject(page)
        pages = mutablePages
    }
    
    /**
    Inserts a Page into the pages set of a Section
    
    :param: page The page that is going to be inserted in the Section
    */
    func insertPageIntoPages(page: Page) {
        let mutablePages = NSMutableSet(set: pages)
        mutablePages.addObject(page)
        pages = mutablePages
    }
    
}