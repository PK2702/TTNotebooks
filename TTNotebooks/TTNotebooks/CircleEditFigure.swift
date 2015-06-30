//
//  CircleEditFigure.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 6/8/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class CircleEditFigure: UIView {
    
    var side: FigureSide!
    
    // MARK: - Drawing

    override func drawRect(rect: CGRect) {
        let padding: CGFloat = 3.0
        let circleBounds = CGRectMake(0.0 + padding / 2, 0.0 + padding / 2, bounds.size.width - padding, bounds.size.height - padding)
        let circlePath = UIBezierPath(ovalInRect: circleBounds)
        UIColor.whiteColor().setFill()
        circlePath.fill()
        UIColor.blackColor().setStroke()
        circlePath.lineWidth = 2.0
        circlePath.stroke()
    }
    
    // MARK: - Initializers
    
    /**
    Initializes a Figure with the given parameters
    
    :param: frame The frame in which the Figure will be drawn
    :param: points The points that represent the edges with which the Figure will be drawn
    :param: fillColor The color of the Figure
    :param: strokeColor The color of the Figure's stroke
    :param: strokeLineWidth The line width of the Figure's stroke
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** Method to set the basic propertis of a UIView */
    func setup() {
        self.opaque = false
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = UIViewContentMode.Redraw
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}
