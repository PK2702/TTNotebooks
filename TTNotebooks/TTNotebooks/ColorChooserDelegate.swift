//
//  ColorChooserDelegate.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 7/1/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

protocol ColorChooserDelegate {
    
    /**
    Tells the delegate a color with the given index was chosen
    
    :param: color The number representing the chosen color
    :param: type The type of color the ColorChooser is editing
    */
    func choseColorWithNumber(color: Int, type: ColorChooserType)
    
    /**
    Tells the delegate that the value of the slider changed
    
    :param: value The new value of the slide
    :param: type The type of color the ColorChooser is editing
    */
    func changedSliderValue(value: Float, type: ColorChooserType)
}