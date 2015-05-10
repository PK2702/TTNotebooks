//
//  Helper.swift
//  TTNotebooks
//  This class will be the helper of all the other classes
//  In here there will be methods that all the other VC will user to
//  Translate model components into UIView components
//  Created by Tomas Trujillo on 3/23/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class Helper {
    
    static private let figureColorZero = (name: "Random", color: UIColor.whiteColor())
    static private let figureColorOne = (name: "White", color: UIColor.whiteColor())
    static private let figureColorTwo = (name: "Green", color: UIColor.greenColor())
    static private let figureColorThree = (name: "Yellow", color: UIColor.yellowColor())
    static private let figureColorFour = (name: "Red", color: UIColor.redColor())
    /** Number of supported colors with which one can draw a Figure */
    static let numberOfFigureColors = 5
    
    static private let notebookColorZero = (name: "Random", color: UIColor.whiteColor())
    static private let notebookColorOne = (name: "White", color: UIColor.whiteColor())
    static private let notebookColorTwo = (name: "Green", color: UIColor.greenColor())
    static private let notebookColorThree = (name: "Yellow", color: UIColor.yellowColor())
    static private let notebookColorFour = (name: "Red", color: UIColor.redColor())
    /** Number of supported colors with which one can draw a Notebook */
    static let numberOfNotebookColors = 5
    
    static private let textFontZero = (name: "Body", font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
    static private let textFontOne = (name: "Caption 1", font: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1))
    static private let textFontTwo = (name: "Caption 2", font: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2))
    static private let textFontThree = (name: "Footnote", font: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote))
    static private let textFontFour = (name: "Headline", font: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline))
    static private let textFontFive = (name: "Subheadline", font: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline))
    /** Number of supported fonts to write in a Page */
    static let numberOfFonts = 6
    
    static private let pagesLayoutZero = "Lined"
    static private let pagesLayoutOne = "Squared"
    static private let pagesLayoutTwo = "Blank"
    /** Number of supported layouts for a page */
    static let numberOfPageLayouts = 3
    
    static private let strokeLineWidthZero = (name: "0.0", stroke: 0.0)
    static private let strokeLineWidthOne = (name: "0.5", stroke: 0.5)
    static private let strokeLineWidthTwo = (name: "1.0", stroke: 1.0)
    static private let strokeLineWidthThree = (name: "1.5", stroke: 1.5)
    static private let strokeLineWidthFour = (name: "2.0", stroke: 2.0)
    static private let strokeLineWidthFive = (name: "2.5", stroke: 2.5)
    static private let strokeLineWidthSix = (name: "3.0", stroke: 3.0)
    /** Number of supported line widths for the stroke of a Figure */
    static let numberOfStrokeLineWidths = 7
    
    /**
    For all the supported numbers, this method returns a Color to paint a Notebook.
    
    :param: number Integer that represents the color with which the Notebook will be painted
    :returns: A UIColor given the number. If the number is outside the supported bounds then it will be clear
    */
    class func notebookColorForNumber (number: Int) -> UIColor {
        switch (number) {
        case 1:
            return notebookColorOne.color
        case 2:
            return notebookColorTwo.color
        case 3:
            return notebookColorThree.color
        case 4:
            return notebookColorFour.color
        default:
            return UIColor.clearColor()
        }
    }
    
    /**
    For all the supported numbers, this method returns the name of the Color to paint a Notebook.
    
    :param: number Integer that represents the color with which the Notebook will be painted
    :returns: The name of the color represented by the number. If the number is outside the supported bounds then it will return an empty string
    */
    class func notebookColorNameForNumber (number: Int) -> String {
        switch (number) {
        case 0:
            return notebookColorZero.name
        case 1:
            return notebookColorOne.name
        case 2:
            return notebookColorTwo.name
        case 3:
            return notebookColorThree.name
        case 4:
            return notebookColorFour.name
        default:
            return ""
        }
    }
    
    /**
    For all the supported numbers, this method returns a Color to paint a figure or its stroke.
    
    :param: number Integer that represents a color with which a figure will be painted. 
    :returns: A UIColor given the number. If the number is outside the supported bounds then it will be clear
    */
    class func figureColorForNumber (number: Int) -> UIColor {
        switch (number) {
        case 1:
            return figureColorOne.color
        case 2:
            return figureColorTwo.color
        case 3:
            return figureColorThree.color
        case 4:
            return figureColorFour.color
        default:
            return UIColor.clearColor()
        }
    }
    
    /**
    For all the supported numbers, this method returns the name of a Color to paint a figure or its stroke.
    
    :param: number Integer that represents a color with which a figure will be painted.
    :returns: The name of a color given the number. If the number is outside the supported bounds then it will be an empty string
    */
    class func figureColorNameForNumber (number: Int) -> String {
        switch (number) {
        case 0:
            return "Random"
        case 1:
            return figureColorOne.name
        case 2:
            return figureColorTwo.name
        case 3:
            return figureColorThree.name
        case 4:
            return figureColorFour.name
        default:
            return ""
        }
    }
    
    /**
    For all the supported numbers, this method returns a text font to take notes.
    
    :param: number Integer representing a font
    :returns: A UIFont to write in a Page. If the number is outside the supported bounds then it will be an empty font
    */
    class func fontForNumber (number: Int) -> UIFont {
        switch (number) {
        case 0:
            return textFontZero.font
        case 1:
            return textFontOne.font
        case 2:
            return textFontTwo.font
        case 3:
            return textFontThree.font
        case 4:
            return textFontFour.font
        case 5:
            return textFontFive.font
        default:
            return UIFont()
        }
    }

    /**
    For all the supported numbers, this method returns the name of a text font to take notes.
    
    :param: number Integer representing a font
    :returns: The name of a font to write in a Page. If the number is outside the supported bounds then it will be an empty string
    */
    class func fontNameForNumber (number: Int) -> String {
        switch (number) {
        case 0:
            return textFontZero.name
        case 1:
            return textFontOne.name
        case 2:
            return textFontTwo.name
        case 3:
            return textFontThree.name
        case 4:
            return textFontFour.name
        case 5:
            return textFontFive.name
        default:
            return ""
        }
    }
    
    /**
    For all the supported numbers, this method returns the name of a page layout.
    
    :param: number Integer representing a type of layout for a Page
    :returns: The name of a page layout. If the number is outside the supported bounds then it will return an empty string
    */
    class func pageLayoutNameForNumber (number: Int) -> String {
        switch (number) {
        case 0:
            return pagesLayoutZero
        case 1:
            return pagesLayoutOne
        case 2:
            return pagesLayoutTwo
        default:
            return ""
        }
    }
    
    /**
    For all the supported numbers, this method returns the line width of the stroke in a figure.
    
    :param: number Integer representing a line width for the stroke of a Figure
    :returns: The width of the line stroke for the Figure. If the number is outside the supported bounds then it will return 0.0
    */
    class func strokeLineWidthForNumber (number: Int) -> Double {
        switch (number) {
        case 0:
            return strokeLineWidthZero.stroke
        case 1:
            return strokeLineWidthOne.stroke
        case 2:
            return strokeLineWidthTwo.stroke
        case 3:
            return strokeLineWidthThree.stroke
        case 4:
            return strokeLineWidthFour.stroke
        case 5:
            return strokeLineWidthFive.stroke
        case 6:
            return strokeLineWidthSix.stroke
        default:
            return 0.0
        }
    }
    
}
