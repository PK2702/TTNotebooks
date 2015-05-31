//
//  Point+CGPoint.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/30/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import UIKit

extension Point {
    func cGPointForCoordinates() -> CGPoint {
        return CGPointMake(CGFloat(xOrigin.doubleValue), CGFloat(yOrigin.doubleValue))
    }
}