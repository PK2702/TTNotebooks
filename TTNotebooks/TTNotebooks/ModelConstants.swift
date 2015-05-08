//
//  ModelConstants.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/4/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation

class ModelConstants {
    
    // MARK - Notebook
    
    struct Notebook {
        static let EntityName = "Notebook"
        static let Color = "color"
        static let Name = "name"
        static let CreationDate = "creationDate"
        static let Sections = "sections"
    }
    
    // MARK - Chapter
    
    struct Section {
        static let EntityName = "Section"
        static let Name = "name"
        static let CreationDate = "creationDate"
        static let Notebook = "notebook"
        static let Pages = "pages"
    }
    
    // MARK - Page
    struct Page {
        static let EntityName = "Page"
        static let CreationDate = "creationDate"
        static let Name = "name"
        static let PageLayout = "pageLayout"
        static let Section = "section"
    }
}