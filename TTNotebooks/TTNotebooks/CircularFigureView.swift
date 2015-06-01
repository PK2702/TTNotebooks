//
//  OvalFigureView.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/31/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class CircularFigureView: FigureView {
    
    override func drawRect(rect: CGRect) {
        let figurePath = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        figurePath.fill()
        strokeColor.setStroke()
        figurePath.lineWidth = strokeLineWidth
        figurePath.stroke()
    }
    
}