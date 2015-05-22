//
//  NotebookCollectionViewCell.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 3/22/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class NotebookCollectionViewCell: UICollectionViewCell {
    
    /** Name of the Notebook that the Collection cell is representing */
    var name: String? {
        didSet{
            self.titleLabel?.text = name
        }
    }
    
    /** Label that will display the name of the Notebook */
    @IBOutlet weak var titleLabel: UILabel! {
        didSet{
            if let notebookTitle = name {
                 titleLabel.text = notebookTitle
            }
        }
    }
    
    var notebook: Notebook?
}
