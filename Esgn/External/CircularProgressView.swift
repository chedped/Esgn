//
//  CircularProgressView.swift
//  CircularProgressView
//
//  Created by Chris Amanse on 1/13/16.
//  Copyright © 2016 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

@IBDesignable
public class CircularProgressView: UIView {
    internal let trackLayer = CAShapeLayer()
    internal let progressLayer = CAShapeLayer()
    
    // MARK: Inspectable
    
    @IBInspectable public var trackWidth: CGFloat = 2 {
        didSet {
            layoutTrackLayer()
        }
    }
    @IBInspectable public var progressWidth: CGFloat = 2 {
        didSet {
            layoutProgressLayer()
        }
    }
    
    @IBInspectable public var trackTintColor: UIColor? = UIColor.lightGray {
        didSet {
            colorTrackLayer()
        }
    }
    @IBInspectable public var progressTintColor: UIColor? = UIColor.darkGray
    
    @IBInspectable public var progress: Float = 0 {
        didSet {
            // Pin values between [0,1]
            if progress < 0 {
                progress = 0
            } else if progress > 1 {
                progress = 1
            } else {
                // Valid value, update stroke
                updateProgressStroke()
            }
        }
    }
    
    // MARK: Drawing properties
    
    private func circleRadiusWithStrokeWidth(strokeWidth: CGFloat, withinSize size: CGSize) -> CGFloat {
        let width = size.width
        let height = size.height
        
        let length = width > height ? height : width
        return (length - strokeWidth) / 2
    }
    private func circleFrameWithStrokeWidth(strokeWidth: CGFloat, withRadius radius: CGFloat, withinSize size: CGSize) -> CGRect {
        let width = size.width
        let height = size.height
        
        let x: CGFloat
        let y: CGFloat
        
        if width > height {
            y = strokeWidth / 2
            x = (width / 2) - radius
        } else {
            x = strokeWidth / 2
            y = (height / 2) - radius
        }
        
        let diameter = 2 * radius
        return CGRect(x: x, y: y, width: diameter, height: diameter)
    }
    internal var trackPath: UIBezierPath {
        let size = bounds.size
        let radius = circleRadiusWithStrokeWidth(strokeWidth: trackWidth, withinSize: size)
        
        return UIBezierPath(ovalIn: circleFrameWithStrokeWidth(strokeWidth: trackWidth, withRadius: radius, withinSize: size))
    }
    internal var progressPath: UIBezierPath {
        let progressPath = UIBezierPath()
        
        let radius = circleRadiusWithStrokeWidth(strokeWidth: progressWidth, withinSize: bounds.size)
        let frame = circleFrameWithStrokeWidth(strokeWidth: progressWidth, withRadius: radius, withinSize: bounds.size)
        let frameCenter = CGPoint(x: (frame.width / 2) + frame.origin.x, y: (frame.height / 2) + frame.origin.y)
        
        progressPath.move( to: CGPoint(x: frameCenter.x, y: frameCenter.y - radius))
        progressPath.addArc(withCenter: frameCenter,
            radius: radius,
            startAngle: CGFloat(-Double.pi / 2),
            endAngle: CGFloat((2 * Double.pi) - Double.pi / 2),
            clockwise: true)
        
        return progressPath
    }
    
    // MARK: Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        customInitialization()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        customInitialization()
    }
    
    public init(frame: CGRect, progress: Float = 0, trackWidth: CGFloat = 2, progressWidth: CGFloat = 2,
        trackTintColor: UIColor, progressTintColor: UIColor) {
            super.init(frame: frame)
            
            self.trackWidth = trackWidth
            self.progressWidth = progressWidth
            self.trackTintColor = trackTintColor
            self.progressTintColor = progressTintColor
            self.progress = progress
            
            customInitialization()
    }
    convenience public init(frame: CGRect, progress: Float = 0, trackWidth: CGFloat, progressWidth: CGFloat) {
        self.init(frame: frame, progress: progress, trackWidth: trackWidth, progressWidth: progressWidth,
            trackTintColor: UIColor.lightGray, progressTintColor: UIColor.darkGray)
    }
    
    convenience public init(frame: CGRect, progress: Float = 0, circleWidth: CGFloat) {
        self.init(frame: frame, progress: progress, trackWidth: circleWidth, progressWidth: circleWidth)
    }
    
    private func customInitialization() {
        let clearCGColor = UIColor.clear.cgColor
        
        trackLayer.fillColor = clearCGColor
        colorTrackLayer()
        layoutTrackLayer()
        
        progressLayer.fillColor = clearCGColor
        
        colorProgressLayer()
        layoutProgressLayer()
        updateProgressStroke()
        
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
    
    // MARK: Layout and color
    
    public override func layoutSubviews() {
        layoutTrackLayer()
        layoutProgressLayer()
    }
    
    private func layoutTrackLayer() {
        trackLayer.frame = bounds
        trackLayer.lineWidth = trackWidth
        trackLayer.path = trackPath.cgPath
    }
    private func colorTrackLayer() {
        trackLayer.strokeColor = trackTintColor?.cgColor
    }
    
    private func layoutProgressLayer() {
        progressLayer.frame = bounds
        progressLayer.lineWidth = progressWidth
        progressLayer.path = progressPath.cgPath
    }
    private func colorProgressLayer() {
        progressLayer.strokeColor = progressTintColor?.cgColor
    }
    private func updateProgressStroke() {
        progressLayer.strokeEnd = CGFloat(progress)
    }
    
    // MARK: Interface builder
    public override func prepareForInterfaceBuilder() {
        customInitialization()
    }
}
