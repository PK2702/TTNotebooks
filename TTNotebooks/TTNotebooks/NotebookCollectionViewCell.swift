//
//  NotebookCollectionViewCell.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 3/22/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class NotebookCollectionViewCell: UICollectionViewCell {
    
    var name: String? {
        didSet{
            self.titleLabel?.text = name
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet{
            if let notebookTitle = name {
                 titleLabel.text = notebookTitle
            }
        }
    }
    
    var notebook: Notebook?
}
