//
//  DiamondEditFigure.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 8/2/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit
/** A view used to represent the edges of a Figure that can be moved to modify its shape. They appear when the user doubles taps the FigureView */
class DiamondEditFigure: UIView {
    
    /** The index of the point where the Diamond is drawn */
    var index: Int
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        let padding: CGFloat = 3.0
        let diamondPath = UIBezierPath()
        diamondPath.moveToPoint(CGPointMake(0.0, frame.size.height / 2))
        diamondPath.addLineToPoint(CGPointMake(frame.size.width / 2, frame.size.height))
        diamondPath.addLineToPoint(CGPointMake(frame.size.width, frame.size.height / 2))
        diamondPath.addLineToPoint(CGPointMake(frame.size.width / 2, 0.0))
        diamondPath.addLineToPoint(CGPointMake(0.0, frame.size.height / 2))
        UIColor.whiteColor().setFill()
        diamondPath.fill()
        UIColor.blackColor().setStroke()
        diamondPath.lineWidth = 2.0
        diamondPath.stroke()
    }
    
    // MARK: - Initializers
    
    /**
    Initializes a DiamondEditFigure with the given parameters
    
    :param: frame The frame in which the Figure will be drawn
    :param: index The index of the point where the EditDiamond is drawn
    */
    init(frame: CGRect, index: Int) {
        self.index = index
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
