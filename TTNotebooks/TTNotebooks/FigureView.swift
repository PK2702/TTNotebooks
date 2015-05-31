//
//  FigureView.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/24/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class FigureView: UIView {

    //MARK: - Variables and Constants
    
    /** The points that represent the edges of the Figure */
    var points: [CGPoint]
    
    /** The color of the Figure */
    var fillColor: UIColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /** The color of the Figure's stroke */
    var strokeColor: UIColor {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /** The line width of the Figure's stroke */
    var strokeLineWidth: CGFloat {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let figurePath = UIBezierPath()
        if let firstPoint = points.first {
            figurePath.moveToPoint(firstPoint)
            for i in 1 ..< points.count {
                figurePath.addLineToPoint(points[i])
            }
            figurePath.addLineToPoint(firstPoint)
        }
        fillColor.setFill()
        figurePath.fill()
        strokeColor.setStroke()
        figurePath.lineWidth = strokeLineWidth
        figurePath.stroke()
    }
    
    //MARK: - Initializers
    
    /**
    Initializes a Figure with the given parameters
    
    :param: frame The frame in which the Figure will be drawn
    :param: points The points that represent the edges with which the Figure will be drawn
    :param: fillColor The color of the Figure
    :param: strokeColor The color of the Figure's stroke
    :param: strokeLineWidth The line width of the Figure's stroke
    */
    init(frame: CGRect, points: [CGPoint], fillColor: UIColor, strokeColor: UIColor, strokeLineWidth: CGFloat) {
        self.points = points
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeLineWidth = strokeLineWidth
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.opaque = false
        self.backgroundColor = nil
        self.contentMode = UIViewContentMode.Redraw
    }
    
}
