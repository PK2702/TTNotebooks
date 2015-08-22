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
    :param: frame The frame where the view will be drawn
    :param: delegate The controller to whom the view will inform of its actions
    :returns: A FigureView created with the Figure
    */
    class func createFigureViewWithFigure(figure: Figure, frame: CGRect, delegate: FigureViewDelegate) -> FigureView{
        let points = figure.points.sortedArrayUsingDescriptors([NSSortDescriptor(key: ModelConstants.Point.OrderInFigure, ascending: true, selector: "compare:")]) as! [Point]
        var coordinates = [CGPoint]()
        for point in points {
            coordinates.append(point.cGPointForCoordinates())
        }
        let fillColor = Helper.figureColorForNumber(figure.fillColor.integerValue)
        let strokeColor = Helper.figureColorForNumber(figure.strokeColor.integerValue)
        let strokeLineWidth = CGFloat(figure.strokeLineWidth.floatValue)
        return FigureView(frame: frame, points: coordinates, fillColor: fillColor, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth, delegate: delegate, alpha: CGFloat(figure.alpha.floatValue))
    }
    
    /**
    Creates a CircularFigureView based on a Figure object
    
    :param: figure The Figure that will be used to create the view
    :param: frame The frame where the view will be drawn
    :param: delegate The controller to whom the view will inform of its actions
    :returns: A CiruclarFigureView created with the Figure
    */
    class func createCircularFigureViewWithFigure(figure: Figure, frame: CGRect, delegate: FigureViewDelegate) -> CircularFigureView{
        var coordinates = [CGPoint]()
        let fillColor = Helper.figureColorForNumber(figure.fillColor.integerValue)
        let strokeColor = Helper.figureColorForNumber(figure.strokeColor.integerValue)
        let strokeLineWidth = CGFloat(figure.strokeLineWidth.floatValue)
        return CircularFigureView(frame: frame, points: coordinates, fillColor: fillColor, strokeColor: strokeColor, strokeLineWidth: strokeLineWidth, delegate: delegate, alpha: CGFloat(figure.alpha.floatValue))
    }
    
    /**
    Creates an ImageFigureView based on a Figure object
    
    :param: figure The Figure that will be used to create the view
    :param: frame The frame where the view will be drawn
    :param: delegate The controller to whom the view will inform of its actions
    :returns: An ImageFigureView created with the Figure
    */
    class func createImageFigureViewWithFigure(figure: Figure, frame: CGRect, delegate: FigureViewDelegate) -> ImageFigureView {
        var image = UIImage()
        if let urlPath = NSURL(string: figure.fileURL) {
            if let imageData = NSData(contentsOfURL: urlPath) {
                if let imageFigure = UIImage(data: imageData) {
                    image = imageFigure
                }
            }
        }
        return ImageFigureView(frame: frame, image: image, delegate: delegate)
    }
}
