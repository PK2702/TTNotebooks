//
//  ColorChooserView.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 7/1/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

class ColorChooserView: UIView {
    
    //MARK: - Properties and Constants
    
    /** Number of color view that will occupy the row */
    private var numberOfViewsPerRow: CGFloat {
        return round(CGFloat(Helper.numberOfNotebookColors) / 2.0)
    }
    
    /** Height of a Color View */
    private var heightOfColorView: CGFloat {
        return (self.frame.size.height - heightOfSlider) / 2
    }
    
    private var heightOfSlider:CGFloat {
        return self.frame.size.height / 5
    }
    
    /** The delegate that will be notified of the choosing of a color */
    var delegate: ColorChooserDelegate!
    
    /** The type of color this view is editing */
    var type: ColorChooserType!
    
    /** A label that indicates the current value of the slider */
    var valueLabel: UILabel?
    
    /** The value with which the value will start */
    var initialValue: Float
    
    //MARK - Drawing
    
    /** Inserts the coloring options in the view */
    private func setup() {
        backgroundColor = UIColor.whiteColor()
        opaque = false
        contentMode = UIViewContentMode.Redraw
        setupColorViews()
        setupSliderAndLabels()
    }
    
    /** Inserts the color views into the ColorChooser */
    private func setupColorViews() {
        let widthOfColorView = self.frame.size.width / numberOfViewsPerRow
        for i in 0 ..< Int(numberOfViewsPerRow) {
            let view = UIView(frame: CGRectMake(CGFloat(i) * widthOfColorView, heightOfSlider, widthOfColorView, heightOfColorView))
            let tapGesture = UITapGestureRecognizer(target: self, action: "tappedOnColor:")
            view.backgroundColor = Helper.figureColorForNumber(i)
            view.tag = i
            view.addGestureRecognizer(tapGesture)
            addSubview(view)
        }
        for i in 0 ..< Int(numberOfViewsPerRow) {
            let view = UIView(frame: CGRectMake(CGFloat(i) * widthOfColorView, heightOfSlider + heightOfColorView, widthOfColorView, heightOfColorView))
            let tapGesture = UITapGestureRecognizer(target: self, action: "tappedOnColor:")
            view.backgroundColor = Helper.figureColorForNumber(i + Int(numberOfViewsPerRow))
            view.tag = i + Int(numberOfViewsPerRow)
            view.addGestureRecognizer(tapGesture)
            addSubview(view)
        }
    }
    
    /** Inserts the slider and label to modify the line width or alpha (depending on the ColorChooserType) */
    private func setupSliderAndLabels() {
        let labelWidth = self.frame.size.width / 6
        let valueLabelWidht = self.frame.size.width / 10
        let slider = UISlider(frame: CGRectMake(labelWidth, 0.0, frame.size.width - labelWidth - valueLabelWidht, heightOfSlider))
        if type == ColorChooserType.FigureFillColor {
            slider.minimumValue = 0.0
            slider.maximumValue = 1.0
        } else if type == ColorChooserType.FigureStrokeColor{
            slider.minimumValue = Float (Helper.strokeLineWidthForNumber(0))
            slider.maximumValue = Float (Helper.strokeLineWidthForNumber(Helper.numberOfStrokeLineWidths - 1))
        }
        slider.setValue(initialValue, animated: true)
        slider.addTarget(self, action: "movedSlider:", forControlEvents: UIControlEvents.ValueChanged)
        
        let valLabel = UILabel(frame: CGRectMake(slider.frame.origin.x + slider.frame.size.width, 0.0, valueLabelWidht, heightOfSlider))
        valLabel.text = "\(slider.minimumValue)"
        valLabel.adjustsFontSizeToFitWidth = true
        valueLabel = valLabel
        
        let label = UILabel(frame: CGRectMake(0.0, 0.0, labelWidth, heightOfSlider))
        label.text = type == .FigureFillColor ? "Alpha" : "Line Width"
        label.adjustsFontSizeToFitWidth = true
        
        addSubview(slider)
        addSubview(valueLabel!)
        addSubview(label)
    }
    
    //MARK: - Gestures
    
    /** Method that is called when one of the colors is tapped */
    func tappedOnColor(tapGesture: UITapGestureRecognizer) {
        if let chosenView = tapGesture.view {
            delegate.choseColorWithNumber(chosenView.tag, type: type)
        }
    }
    
    /** Method that gets called when the value of the slider changes */
    func movedSlider(slider: UISlider) {
        valueLabel?.text = "\(round(slider.value * 100.0) / 100)"
        delegate.changedSliderValue(slider.value, type: type)
    }
    
    //MARK: - Initializers
    
    /**
    Creates a new instance of the Class ColorChooserView within a given frame and a certain color chooser type
    
    :param: frame The frame in which the ColorChooserType is going to be enclosed
    :param: type The type that the ColorChooserView is going to be
    :param: value The initial value of the slider be it alpha or stroke line widht
    */
    init(frame: CGRect, type: ColorChooserType, value: Float) {
        self.type = type
        initialValue = value
        super.init(frame: frame)
        setup()
    }
    
    override init(frame: CGRect) {
        self.type = .FigureFillColor
        initialValue = 0.0
        super.init(frame: frame);
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}
