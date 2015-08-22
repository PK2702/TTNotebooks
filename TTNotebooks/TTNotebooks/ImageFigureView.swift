//
//  ImageFigureView.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 8/20/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class ImageFigureView: FigureView {
    
    // MARK: - Variables
    
    /** UIImageview where the ImageFigureView's Image will be displayed */
    private var imageView: UIImageView!
    
    /** UIImage that the ImageFigureView will represent */
    var image: UIImage
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        imageView.frame = self.bounds
    }
    
    // MARK: - Setup
    
    /**
    Initializes an ImageFigureView with that will display the given Image
    
    :param: image The image that will be shown in this ImageFigureView
    :returns: an ImageFigureView
    */
    init(frame: CGRect, image:UIImage, delegate: FigureViewDelegate) {
        self.image = image
        super.init(frame: frame, points: [CGPoint](), fillColor: UIColor.clearColor(), strokeColor: UIColor.clearColor(), strokeLineWidth: 0.0, delegate: delegate, alpha: 1.0)
        imageView = UIImageView(frame: self.bounds)
        imageView.image = image
        self.addSubview(imageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
