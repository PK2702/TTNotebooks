//
//  FigureViewDelegate.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 6/3/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation

protocol FigureViewDelegate {
    
    
    /**
    Notifies the delegate that the figure was touched
    
    :param: figureView The FigureView that was touched
    :param: editing Indicates wether the editing of the FigureView started or ended
    :returns:
    */
    func selectedFigureView(figureView: FigureView, editing: Bool)
    
}