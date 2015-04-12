//
//  Notebook.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 4/12/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import Foundation
import CoreData

class Notebook: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var color: NSNumber

}
