//
//  NotebookView.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 3/21/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class NotebookView: UIView {

    var name: String? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        var nameLabel = NSAttributedString(string: name!, attributes: [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)])
        let size = nameLabel.size()
        let nameLabelOrigin = CGPointMake(bounds.midX - size.width/2, bounds.midY - size.height/2)
        let borderTitle =  nameLabel.size().height/2
        let titleBezierPath = UIBezierPath()
        titleBezierPath.moveToPoint(CGPointMake(nameLabelOrigin.x - borderTitle, nameLabelOrigin.y - borderTitle))
        titleBezierPath.addLineToPoint(CGPointMake(nameLabelOrigin.x + nameLabel.size().width + borderTitle, nameLabelOrigin.y - borderTitle))
        titleBezierPath.addLineToPoint(CGPointMake(nameLabelOrigin.x + nameLabel.size().width + borderTitle, nameLabelOrigin.y + nameLabel.size().height + borderTitle))
        titleBezierPath.addLineToPoint(CGPointMake(nameLabelOrigin.x - borderTitle, nameLabelOrigin.y + nameLabel.size().height + borderTitle))
        titleBezierPath.closePath()
        UIColor.blackColor().setStroke()
        UIColor.whiteColor().setFill()
        titleBezierPath.stroke()
        titleBezierPath.fill()
        nameLabel.drawAtPoint(nameLabelOrigin)
    }
    
    func setup() {
        name = "This is a Notebook Test"
        self.opaque = false
        self.backgroundColor = UIColor.greenColor()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

}
