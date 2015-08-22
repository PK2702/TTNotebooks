//
//  NotebooksUIImagePickerController.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 8/22/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class NotebooksUIImagePickerController: UIImagePickerController {

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
}
