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
    
    //  For all the suported numbers, this method returns a Color. If the number is outside the supported bounds than it will be red
    class func colorForNumber (number: Int) -> UIColor {
        switch (number) {
        case 1:
            return UIColor.whiteColor()
        case 2:
            return UIColor.greenColor()
        case 3:
            return UIColor.yellowColor()
        default:
            return UIColor.redColor()
        }
    }

}
