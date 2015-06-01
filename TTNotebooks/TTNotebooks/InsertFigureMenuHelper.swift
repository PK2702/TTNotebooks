//
//  InsertFigureMenuHelper.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/24/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation

enum InsertFigureType {
    case SquareFigure
    case RectangleFigure
    case RhombusFigure
    case TriangleFigure
    case CircleFigure
    case OvalFigure
    case CylinderFigure
    case PhotoFigure
    case ImageFigure
    case AudioFigure
    case VideoFigure
    case GraphFigure
    case EquationFigure
    case AngleFigure
    case NoFigure
}

class InsertFigureMenuHelper {
    
    // MARK: - Constants
    
    //Section 1: Figures
    static let Section1Figure1 = (name:"Square", type: InsertFigureType.SquareFigure)
    static let Section1Figure2 = (name:"Rectangle", type: InsertFigureType.RectangleFigure)
    static let Section1Figure3 = (name:"Rhombus", type: InsertFigureType.RhombusFigure)
    static let Section1Figure4 = (name:"Triangle", type: InsertFigureType.TriangleFigure)
    static let Section1Figure5 = (name:"Circle", type: InsertFigureType.CircleFigure)
    static let Section1Figure6 = (name:"Oval", type: InsertFigureType.OvalFigure)
    static let FiguresSection1 = [Section1Figure1, Section1Figure2, Section1Figure3, Section1Figure4, Section1Figure5, Section1Figure6]
    static let Section1 = (name: "Figures", content: FiguresSection1)
    
    static let Section2Figure1 = (name:"Photo", type: InsertFigureType.PhotoFigure)
    static let Section2Figure2 = (name:"Image", type: InsertFigureType.ImageFigure)
    static let Section2Figure3 = (name:"Audio", type: InsertFigureType.AudioFigure)
    static let Section2Figure4 = (name:"Video", type: InsertFigureType.VideoFigure)
    static let FiguresSection2 = [Section2Figure1, Section2Figure2, Section2Figure3, Section2Figure4]
    static let Section2 = (name: "Multimedia", content: FiguresSection2)
    
    static let Section3Figure1 = (name:"Graph", type: InsertFigureType.GraphFigure)
    static let Section3Figure2 = (name:"Equation", type: InsertFigureType.EquationFigure)
    static let Section3Figure3 = (name:"Angle", type: InsertFigureType.AngleFigure)
    static let FiguresSection3 = [Section3Figure1, Section3Figure2, Section3Figure3]
    static let Section3 = (name: "Functions", content: FiguresSection3)
    
    static let Sections = [Section1, Section2, Section3]
    
    // MARK: - Functions
    
    /**
    Number of sections in the Insert Figure Menu
    
    :returns: The number of sections that the menu has
    */
    static func numberOfSections() -> Int {
        return Sections.count
    }
    
    /**
    Number of rows in the Insert Figure Menu
    
    :param: section The index of the section whose rows are going to be counted
    :returns: The number of rows that the menu has
    */
    static func numberOfRowsForSection(section: Int) -> Int {
        return Sections[section].content.count
    }
    
    /**
    Name the section in the given index
    
    :param: section The index of the section whose name is going to be returned
    :returns: The name of the section
    */
    static func nameForSection(section: Int) -> String {
        return Sections[section].name
    }
    
    /**
    Figure type for the cell at a given section at a given row
    
    :param: section The section in the Menu of the selected cell
    :param: row The row in the Menu of the selected cell
    :returns: The FigureType of the Figure that is going to be inserted in the Page
    */
    static func figureTypeForSection(section: Int, row: Int) -> InsertFigureType {
        return Sections[section].content[row].type
    }
    
    /**
    Name for the cell at a given section at a given row
    
    :param: section The section in the Menu of the selected cell
    :param: row The row in the Menu of the selected cell
    :returns: The name of the Figure that is going to be inserted in the Page
    */
    static func nameOfFigureForSection(section: Int, row: Int) -> String {
        return Sections[section].content[row].name
    }
}