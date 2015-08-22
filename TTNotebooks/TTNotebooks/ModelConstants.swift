//
//  ModelConstants.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/4/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation

class ModelConstants {
    
    // MARK: - Notebook
    
    struct Notebook {
        static let EntityName = "Notebook"
        static let Color = "color"
        static let Name = "name"
        static let CreationDate = "creationDate"
        static let Sections = "sections"
    }
    
    // MARK: - Section
    
    struct Section {
        static let EntityName = "Section"
        static let Name = "name"
        static let CreationDate = "creationDate"
        static let Notebook = "notebook"
        static let Pages = "pages"
        static let OrderInNotebook = "orderInNotebook"
    }
    
    // MARK: - Page
    struct Page {
        static let EntityName = "Page"
        static let CreationDate = "creationDate"
        static let Name = "name"
        static let PageLayout = "pageLayout"
        static let Section = "section"
        static let OrderInSection = "orderInSection"
    }
    
    // MARK: - Figure
    struct Figure{
        static let EntityName = "Figure"
        static let FillColor = "fillColor"
        static let Height = "height"
        static let StrokeColor = "strokeColor"
        static let StrokeLineWidth = "strokeLineWidth"
        static let Type = "type"
        static let Width = "width"
        static let Page = "page"
        static let Points = "points"
        static let XOrigin = "xOrigin"
        static let YOrigin = "yOrigin"
        static let OrderInPage = "orderInPage"
        static let FileURL = "fileURL"
    }
    
    // MARK: - Point
    struct Point {
        static let EntityName = "Point"
        static let OrderInFigure = "orderInFigure"
        static let XOrigin = "xOrigin"
        static let YOrigin = "yOrigin"
        static let Figure = "figure"
    }
}