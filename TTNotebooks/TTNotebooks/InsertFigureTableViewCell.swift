//
//  InsertFigureTableViewCell.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/24/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class InsertFigureTableViewCell: UITableViewCell {

    // MARK: - Variables and Constants
    
    /** ImageView that shows a preview of the figure that the cell represents */
    @IBOutlet weak var figureImageView: UIImageView!
    
    /** Label that displays the Figure's name */
    @IBOutlet weak var figureName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
