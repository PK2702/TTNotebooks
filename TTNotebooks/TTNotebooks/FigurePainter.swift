//
//  FigurePainter.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 6/6/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class FigurePainter {
    /**
    Creates a FigureView based on a Figure object
    
    :param: figure The Figure that will be used to create the view
    :returns: A FigureView created with the Figure
    */
    class func createFigureViewWithFigure(figure: Figure, frame: CGRect) -> FigureView{
        let points = figure.points.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Point.OrderInFigure, ascending: true, selector: "compare:")]) as! [Point]
        var coordinates = [CGPoint]()
        for point in points {
            coordinates.append(point.cGPointForCoordinates())
        }
        let fillColor = Helper.figureColorForNumber(figure.fillColor.integerValue)
        let strokeColor = Helper.figureColorForNumber(figure.strokeColor.integerValue)
        let strokeLineWidth = CGFloat(Helper.strokeLineWidthForNumber(figure.strokeLineWidth.integerValue))
        return FigureView(frame: frame, points: coordinates, fillColor: fillColor, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth)
    }
    
    /**
    Creates a CircularFigureView based on a Figure object
    
    :param: figure The Figure that will be used to create the view
    :returns: A CiruclarFigureView created with the Figure
    */
    class func createCircularFigureViewWithFigure(figure: Figure, frame: CGRect) -> CircularFigureView{
        var coordinates = [CGPoint]()
        let fillColor = Helper.figureColorForNumber(figure.fillColor.integerValue)
        let strokeColor = Helper.figureColorForNumber(figure.strokeColor.integerValue)
        let strokeLineWidth = CGFloat(Helper.strokeLineWidthForNumber(figure.strokeLineWidth.integerValue))
        return CircularFigureView(frame: frame, points: coordinates, fillColor: fillColor, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth)
    }
}
