//
//  FigureViewDelegate.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 6/3/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

protocol FigureViewDelegate {
    
    
    /**
    Notifies the delegate that the figure was touched
    
    :param: figureView The FigureView that was touched
    :param: editing Indicates wether the editing of the FigureView started or ended
    */
    func selectedFigureView(figureView: FigureView, editing: Bool)
    
    /**
    Notifies the delegate that the figure's frame and points were updated
    
    :param: figureView The FigureView that was updated
    :param: frame The updated frame of the FigureView
    :param: points The updated points that draw the FigureView
    */
    func updateFigureViewFrameAndPoints(figureView: FigureView, frame: CGRect, points: [CGPoint])
    
    /**
    Notifies the delegate that the figure will present the MenuController
    
    :param: frame The frame to which the MenuController will be attached
    */
    func displayMenuControllerForFigureInFrame(figureView: FigureView, frame: CGRect)
    
}