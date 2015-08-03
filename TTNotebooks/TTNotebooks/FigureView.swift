//
//  FigureView.swift
//  TTNotebooks
//
//  Created by Tomas Trujillo on 5/24/15.
//  Copyright (c) 2015 TTApps. All rights reserved.
//

import UIKit

private enum PointLocation {
    case BeforeCenter
    case AfterCenter
    case JustInTheCenter
}

class FigureView: UIView {

    // MARK: - Variables and Constants
    
    /** The points that represent the edges of the Figure */
    var points: [CGPoint]
    
    /** Keeps stored the location of its respective point to the middle in the Y-axis */
    private var pointsLocationsInY = [PointLocation]()
    
    /** Keeps stored the location of its respective point to the middle in the X-axis */
    private var pointsLocationsInX = [PointLocation]()
    
    /** Collection of the circle edit views in the figure */
    private var circleEditViews = [FigureSide : CircleEditFigure]()
    
    /** Colleciton of the diamond edit view in the figure points */
    private var editDiamondViews = [DiamondEditFigure]()
    
    /** The color of the Figure */
    var fillColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /** The color of the Figure's stroke */
    var strokeColor: UIColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /** The line width of the Figure's stroke */
    var strokeLineWidth: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /** The alpha of the fill color */
    var alphaColor: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /** The index of the Figure, that this view represents, in the Page */
    var index: Int!
    
    /** The delegate that will be notified when the user interacts with the FigureView */
    var delegate: FigureViewDelegate
    
    /** Indicates wether the view is in editing mode or not */
    var editing = false {
        didSet {
            if editing {
                addEditCircleViews()
            } else {
                removeEditCircleView()
            }
            setNeedsDisplay()
        }
    }
    
    /** Indicates wether the view is in editing sahpe mode or not */
    var editingShape = false {
        didSet {
            if editingShape {
                addEditDiamondViews()
            } else {
                removeEditDiamondView()
            }
            setNeedsDisplay()
        }
    }
    
    /** The Size of the view of the figures that represent editing actions in the */
    let fractionOfEditFigureSize :CGFloat = 0.2
    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
//        println("Number of views: \(self.subviews.count)")
        let figurePath = UIBezierPath()
        if let firstPoint = points.first {
            figurePath.moveToPoint(firstPoint)
            for i in 1 ..< points.count {
                figurePath.addLineToPoint(points[i])
            }
            figurePath.addLineToPoint(firstPoint)
        }
        
        fillColor.colorWithAlphaComponent(alphaColor).setFill()
        figurePath.fill()
        strokeColor.setStroke()
        figurePath.lineWidth = strokeLineWidth
        figurePath.stroke()
    }
    
    /** Adds edit circles to the edges of the figure */
    private func addEditCircleViews() {
        circleEditViews = [FigureSide : CircleEditFigure]()
        let editFigureSize = min(bounds.size.width, bounds.size.height) * fractionOfEditFigureSize
        let leftCircleEditFigure = CircleEditFigure(frame: CGRectMake(0.0 - editFigureSize / 2, bounds.size.height / 2 - editFigureSize / 2, editFigureSize, editFigureSize));
        leftCircleEditFigure.side = FigureSide.WestSide
        let upperCircleEditFigure = CircleEditFigure(frame: CGRectMake(bounds.size.width / 2 - editFigureSize / 2, 0.0 - editFigureSize / 2, editFigureSize, editFigureSize))
        upperCircleEditFigure.side = FigureSide.NorthSide
        let rightCircleEditFigure = CircleEditFigure(frame: CGRectMake(bounds.size.width - editFigureSize / 2, bounds.size.height / 2 - editFigureSize / 2, editFigureSize, editFigureSize))
        rightCircleEditFigure.side = FigureSide.EastSide
        let lowerCircleEditFigure = CircleEditFigure(frame: CGRectMake(bounds.size.width / 2 - editFigureSize / 2, bounds.size.height - editFigureSize / 2, editFigureSize, editFigureSize))
        lowerCircleEditFigure.side = FigureSide.SouthSide
        let leftPanGesture = UIPanGestureRecognizer(target: self, action: "moveCircleEditFigure:")
        let rightPanGesture = UIPanGestureRecognizer(target: self, action: "moveCircleEditFigure:")
        let lowerPanGesture = UIPanGestureRecognizer(target: self, action: "moveCircleEditFigure:")
        let upperPanGesture = UIPanGestureRecognizer(target: self, action: "moveCircleEditFigure:")
        self.addSubview(lowerCircleEditFigure)
        self.addSubview(rightCircleEditFigure)
        self.addSubview(upperCircleEditFigure)
        self.addSubview(leftCircleEditFigure)
        leftCircleEditFigure.addGestureRecognizer(leftPanGesture)
        rightCircleEditFigure.addGestureRecognizer(rightPanGesture)
        upperCircleEditFigure.addGestureRecognizer(upperPanGesture)
        lowerCircleEditFigure.addGestureRecognizer(lowerPanGesture)
        circleEditViews[FigureSide.WestSide] = leftCircleEditFigure
        circleEditViews[FigureSide.EastSide] = rightCircleEditFigure
        circleEditViews[FigureSide.SouthSide] = lowerCircleEditFigure
        circleEditViews[FigureSide.NorthSide] = upperCircleEditFigure
    }
    
    /** Removes the edit circles from the figure */
    private func removeEditCircleView() {
        for (_, editCircle) in circleEditViews {
            editCircle.removeFromSuperview()
        }
    }
    
    /** Adds edit circles to the edges of the figure */
    private func addEditDiamondViews() {
        editDiamondViews = [DiamondEditFigure]()
        let editFigureSize = min(bounds.size.width, bounds.size.height) * fractionOfEditFigureSize
        var i = 0
        for point in points {
            let editDiamondView = DiamondEditFigure(frame: CGRectMake(point.x - editFigureSize / 2, point.y - editFigureSize / 2, editFigureSize, editFigureSize), index: i)
            let panGesture = UIPanGestureRecognizer(target: self, action: "moveDiamondEditFigure:")
            self.addSubview(editDiamondView)
            editDiamondView.addGestureRecognizer(panGesture)
            editDiamondViews.append(editDiamondView)
            i++
        }
    }
    
    /** Removes the edit diamond from the figure */
    private func removeEditDiamondView() {
        for editDiamond in editDiamondViews {
            editDiamond.removeFromSuperview()
        }
    }
    
    /** Resizes the edit circles and replaces them given that the views bounds have changed */
    private func resizeAndReplaceEditCircles() {
        let editFigureSize = min(bounds.size.width, bounds.size.height) * fractionOfEditFigureSize
        for (side , circleView) in circleEditViews {
            switch (side) {
            case FigureSide.SouthSide:
                circleView.frame = CGRectMake(bounds.size.width / 2 - editFigureSize / 2, bounds.size.height - editFigureSize / 2, editFigureSize, editFigureSize)
            case FigureSide.NorthSide:
                circleView.frame = CGRectMake(bounds.size.width / 2 - editFigureSize / 2, 0.0 - editFigureSize / 2, editFigureSize, editFigureSize)
            case FigureSide.EastSide:
                circleView.frame = CGRectMake(bounds.size.width - editFigureSize / 2, bounds.size.height / 2 - editFigureSize / 2, editFigureSize, editFigureSize)
            case FigureSide.WestSide:
                circleView.frame = CGRectMake(0.0 - editFigureSize / 2, bounds.size.height / 2 - editFigureSize / 2, editFigureSize, editFigureSize)
            }
        }
    }
    
    /** Resizes the edit diamonds and replaces them given that the views bounds have changed */
    private func resizeAndReplaceEditDiamonds() {
        let editFigureSize = min(bounds.size.width, bounds.size.height) * fractionOfEditFigureSize
        var i  = 0
        for editDiamondView in editDiamondViews {
            let point = points[i]
            editDiamondView.frame = CGRectMake(point.x - editFigureSize / 2, point.y - editFigureSize / 2, editFigureSize, editFigureSize)
            i++
        }
    }
    
    // MARK: - Point Location and Displacement
    
    /** Updates the location of every point with respect to the center */
    private func updatePointsLocation() {
        let centerX: CGFloat = frame.size.width / 2.0
        let centerY: CGFloat = frame.size.height / 2.0
        pointsLocationsInX = [PointLocation]()
        pointsLocationsInY = [PointLocation]()
        for i in 0 ..< points.count {
            let point = points[i]
            pointsLocationsInX.append(determinePointLocation(point.x, center: centerX))
            pointsLocationsInY.append(determinePointLocation(point.y, center: centerY))
        }
    }
    
    /**
    Determines the location of a point with respect to the center for one axis
    
    :param: pointCoordinate The coordinate, in one axis, of the point to be located
    :param: center The center coordinate, in one axis, of the center
    */
    private func determinePointLocation(pointCoordinate: CGFloat, center: CGFloat) -> PointLocation {
        if pointCoordinate < center {
            return PointLocation.BeforeCenter
        } else if pointCoordinate > center {
            return PointLocation.AfterCenter
        } else {
            return PointLocation.JustInTheCenter
        }
    }
    
    /**
    Method that searches the array of points in the figure and return the minimum value for x coordinate
    
    :returns: The minimum x coordinate that the points have
    */
    private func getMinimumX() ->CGFloat {
        var minX: CGFloat = 999999.0
        for point in points {
            if point.x < minX {
                minX = point.x
            }
        }
        return minX
    }
    
    /**
    Method that searches the array of points in the figure and return the minimum value for y coordinate
    
    :returns: The minimum y coordinate that the points have
    */
    private func getMinimumY() ->CGFloat {
        var minY: CGFloat = 999999.0
        for point in points {
            if point.y < minY {
                minY = point.y
            }
        }
        return minY
    }
    
    /**
    Method that searches the array of points in the figure and return the maximum value for x coordinate
    
    :returns: The maximum x coordinate that the points have
    */
    private func getMaximumX() -> CGFloat{
        var maxX: CGFloat = 0.0
        for point in points {
            if point.x > maxX {
                maxX = point.x
            }
        }
        return maxX
    }
    
    /**
    Method that searches the array of points in the figure and return the maximum value for y coordinate
    
    :returns: The maximum y coordinate that the points have
    */
    private func getMaximumY() -> CGFloat{
        var maxY: CGFloat = 0.0
        for point in points {
            if point.y > maxY {
                maxY = point.y
            }
        }
        return maxY
    }
    
    /**
    Moves both of the point's coordinates using the given scale
    
    :param: scale The sacle by which the points will be multiplied
    :param: index The index of the point that will be updated
    */
    private func movePointWithScale(scale: CGFloat, index: Int) {
        let point = points[index]
        let locationInX = pointsLocationsInX[index]
        let locationInY = pointsLocationsInY[index]
        var deltaX: CGFloat = 0.0
        var deltaY: CGFloat = 0.0
        let deltaScale = (scale - 1.0)
        switch (locationInX) {
        case PointLocation.BeforeCenter:
            deltaX = 0.0
        case PointLocation.AfterCenter:
            deltaX = (deltaScale * self.frame.size.width)
        case PointLocation.JustInTheCenter:
            deltaX = (deltaScale * self.frame.size.width) / 2
        default:
            break
        }
        switch (locationInY) {
        case PointLocation.BeforeCenter:
            deltaY = 0.0
        case PointLocation.AfterCenter:
            deltaY = (deltaScale * self.frame.size.height)
        case PointLocation.JustInTheCenter:
            deltaY = (deltaScale * self.frame.size.height) / 2
        default:
            break
        }
        points[index].x += deltaX
        points[index].y += deltaY
    }
    
    /**
    Moves both of the point's coordinates using the given displacements in the x and y axis
    
    :param: deltaWidth The displacement in the X axis
    :param: deltaHeight The displacement in the Y axis
    */
    private func movePointWithDeltas(deltaWidth: CGFloat, deltaHeight: CGFloat, index: Int) {
        let point = points[index]
        let locationInX = pointsLocationsInX[index]
        let locationInY = pointsLocationsInY[index]
        var deltaX: CGFloat = 0.0
        var deltaY: CGFloat = 0.0
        switch (locationInX) {
        case PointLocation.BeforeCenter:
            deltaX = 0.0
        case PointLocation.AfterCenter:
            deltaX = deltaWidth
        case PointLocation.JustInTheCenter:
            deltaX = deltaWidth / 2
        default:
            break
        }
        switch (locationInY) {
        case PointLocation.BeforeCenter:
            deltaY = 0.0
        case PointLocation.AfterCenter:
            deltaY = deltaHeight
        case PointLocation.JustInTheCenter:
            deltaY = deltaHeight / 2
        default:
            break
        }
        points[index].x += deltaX
        points[index].y += deltaY
    }
    // MARK: - Gestures
    
    /** Method that will be called when the FigureView is tapped */
    func figureTouched(tapGestureRecognizer: UITapGestureRecognizer) {
        editing = !editing
        editingShape = false
        delegate.selectedFigureView(self, editing: editing)
        
    }
    
    /** Method that will be called when the FigureView is double tapped */
    func figureDoubleTouched(tapGestureRecognizer: UITapGestureRecognizer) {
        editingShape = !editingShape
        editing = false
        delegate.doubleTappedFigureView(self, editingShape: editingShape)
    }
    
    /** Method that will be called when the figureView is pinched */
    func figurePinched(pinchGesture: UIPinchGestureRecognizer) {
        if pinchGesture.state == UIGestureRecognizerState.Ended {
            delegate.updateFigureViewFrameAndPoints(self, frame: self.frame, points: self.points)
        } else {
            let scale = pinchGesture.scale
            for i in 0 ..< points.count {
                movePointWithScale(scale, index: i)
            }
            let deltaScale = scale - 1.0
            let deltaX = (deltaScale * self.frame.size.width) * -1
            let deltaY = (deltaScale * self.frame.size.height) * -1
            self.frame = CGRectMake(self.frame.origin.x + deltaX / 2, self.frame.origin.y + deltaY / 2, self.frame.size.width - deltaX, self.frame.size.height - deltaY)
            pinchGesture.scale = 1.0
            setNeedsDisplay()
        }
        removeEditCircleView()
        addEditCircleViews()
    }
    
    /** Method that is called when the user long presses on the figure */
    func figureLongPressed(longPressGesture: UILongPressGestureRecognizer) {
        if longPressGesture.state == UIGestureRecognizerState.Began {
            delegate.displayMenuControllerForFigureInFrame(self, frame: self.bounds)
        }
    }
    
    /** Method called when an EditCircle is moved. This method adjusts the view's frame in response to the displacement */
    func moveCircleEditFigure(panGessture: UIPanGestureRecognizer) {
        if let editCircle = panGessture.view as? CircleEditFigure {
            let gesturePoint = panGessture.locationInView(self)
            var deltaOriginX: CGFloat = 0.0
            var deltaOriginY: CGFloat = 0.0
            var deltaWidth: CGFloat = 0.0
            var deltaHeight: CGFloat = 0.0
            let side = editCircle.side!
            switch (side) {
            case FigureSide.EastSide:
                deltaWidth = gesturePoint.x - self.frame.size.width
            case FigureSide.WestSide:
                deltaOriginX = gesturePoint.x
                deltaWidth = -1 * deltaOriginX
            case FigureSide.SouthSide:
                deltaHeight = gesturePoint.y - self.frame.size.height

            case FigureSide.NorthSide:
                deltaOriginY = gesturePoint.y
                deltaHeight = -1 * deltaOriginY
            }
            self.frame = CGRectMake(self.frame.origin.x + deltaOriginX, self.frame.origin.y + deltaOriginY, self.frame.size.width + deltaWidth, self.frame.size.height + deltaHeight)
            for i in 0 ..< points.count {
                movePointWithDeltas(deltaWidth, deltaHeight: deltaHeight, index: i)
            }
            resizeAndReplaceEditCircles()
            delegate.updateFigureViewFrameAndPoints(self, frame: frame, points: points)
            setNeedsDisplay()
        }
    }
    
    /** Method called when an EditDiamon is moved. This method adjusts the view's frame in response to the displacement */
    func moveDiamondEditFigure(panGesture: UIPanGestureRecognizer) {
        if let editDiamond = panGesture.view as? DiamondEditFigure {
            let gesturePoint = panGesture.locationInView(self)
            let index = editDiamond.index
            var point = points[index]
            var deltaOriginX: CGFloat = 0.0
            var deltaOriginY: CGFloat = 0.0
            var deltaWidth: CGFloat = 0.0
            var deltaHeight: CGFloat = 0.0
            point = gesturePoint
            points[index] = point
            let minX = getMinimumX()
            let minY = getMinimumY()
            let maxX = getMaximumX()
            let maxY = getMaximumY()
            //X axis
            if gesturePoint.x == maxX {
                deltaWidth = gesturePoint.x - frame.size.width
            }else if gesturePoint.x  == minX {
                deltaWidth = 0.0 - gesturePoint.x
                deltaOriginX = deltaWidth * -1
            }
            //Y axis
            if gesturePoint.y == maxY {
                deltaHeight = gesturePoint.y - frame.size.height
            } else if gesturePoint.y == minY {
                deltaHeight = 0.0 - gesturePoint.y
                deltaOriginY = deltaHeight * -1
            }
            self.frame = CGRectMake(self.frame.origin.x + deltaOriginX, self.frame.origin.y + deltaOriginY, self.frame.size.width + deltaWidth, self.frame.size.height + deltaHeight)
            if deltaOriginX != 0 || deltaOriginY != 0 {
                for i in 0 ..< points.count {
                    if i != index {
                        var pointToMove = points[i]
                        pointToMove.x += deltaOriginX * -1.0
                        pointToMove.y += deltaOriginY * -1.0
                        points[i] = pointToMove
                    }
                }
            }
            resizeAndReplaceEditDiamonds()
            delegate.updateFigureViewFrameAndPoints(self, frame: frame, points: points)
            setNeedsDisplay()
        }
    }
    
    // MARK: - Initializers
    
    /**
    Initializes a Figure with the given parameters
    
    :param: frame The frame in which the Figure will be drawn
    :param: points The points that represent the edges with which the Figure will be drawn
    :param: fillColor The color of the Figure
    :param: strokeColor The color of the Figure's stroke
    :param: strokeLineWidth The line width of the Figure's stroke
    */
    init(frame: CGRect, points: [CGPoint], fillColor: UIColor, strokeColor: UIColor, strokeLineWidth: CGFloat, delegate: FigureViewDelegate, alpha: CGFloat) {
        self.points = points
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.strokeLineWidth = strokeLineWidth
        self.delegate = delegate
        self.alphaColor = alpha
        super.init(frame: frame)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "figureTouched:")
        self.addGestureRecognizer(tapGestureRecognizer)
        let longPressedGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "figureLongPressed:")
        self.addGestureRecognizer(longPressedGestureRecognizer)
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "figureDoubleTouched:")
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureRecognizer)
        tapGestureRecognizer.requireGestureRecognizerToFail(doubleTapGestureRecognizer)
        updatePointsLocation()
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** Method to set the basic propertis of a UIView */
    func setup() {
        self.opaque = false
        self.backgroundColor = UIColor.clearColor()
        self.contentMode = UIViewContentMode.Redraw
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}
