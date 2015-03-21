//
//  StarButton.swift
//  StarButton
//
//  Created by luojie on 3/21/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable

class StarButton: UIButton {

    private var starShap : CAShapeLayer!
    private var outerRingShape : CAShapeLayer!
    private var fillRingShape : CAShapeLayer!
    
    private let startKey = "FAVANIMKEY"
    private let favoriteKey = "FAVORITE"
    private let notFavoriteKey = "NOTFAVORITE"
    
    @IBInspectable
    var lineWidth: CGFloat = 1 {
        didSet { updateLayerProperties() }
    }
    
    
    @IBInspectable
    var favoriteColor: UIColor = UIColor(hex:"eecd34") {
        didSet { updateConstraints() }
    }
    
    @IBInspectable
    var notFavoriteColor: UIColor = UIColor(hex: "9e9b9b") {
        didSet { updateConstraints() }
    }
    
    @IBInspectable
    var starFavoriteColor: UIColor = UIColor(hex: "9e9b9b") {
        didSet { updateConstraints() }
    }
    
    var isFavorite :Bool = false {
        didSet {
            return self.isFavorite ? favorite() : notFavorite()
        }
    }
    
    
    private func createLayersIfNeeded(){
        
        if fillRingShape == nil {
            fillRingShape = CAShapeLayer()
            fillRingShape.path = Paths.circle(frameWithInset())
            fillRingShape.bounds = CGPathGetBoundingBox(fillRingShape.path)
            fillRingShape.fillColor = favoriteColor.CGColor
            fillRingShape.lineWidth = lineWidth
            fillRingShape.position = CGPoint(
                x: CGRectGetWidth(fillRingShape.bounds)/2,
                y: CGRectGetHeight(fillRingShape.bounds)/2
            )
            fillRingShape.transform = CATransform3DMakeScale(0.2, 0.2, 0.2)
            fillRingShape.opacity = 0
            self.layer.addSublayer(fillRingShape)
        }
        
        if outerRingShape == nil {
            outerRingShape = CAShapeLayer()
            outerRingShape.path = Paths.circle(frameWithInset())
            outerRingShape.bounds = frameWithInset()
            outerRingShape.lineWidth = lineWidth
            outerRingShape.strokeColor = notFavoriteColor.CGColor
            outerRingShape.fillColor = UIColor.clearColor().CGColor
            outerRingShape.position = CGPoint(
                x: CGRectGetWidth(self.bounds)/2,
                y: CGRectGetHeight(self.bounds)/2
            )
            outerRingShape.transform = CATransform3DIdentity
            outerRingShape.opacity = 0.5
            self.layer.addSublayer(outerRingShape)
        }
        
        if starShap == nil {
            var starFrame = self.bounds
            starFrame.size.width = CGRectGetWidth(starFrame)/2.5
            starFrame.size.height = CGRectGetHeight(starFrame)/2.5
            
            starShap = CAShapeLayer()
            starShap.path = CGPath.rescaleForFrame(
                path: Paths.star,
                frame: starFrame)
            starShap.bounds = CGPathGetBoundingBox(starShap.path)
            starShap.fillColor = notFavoriteColor.CGColor
            starShap.position = CGPoint(
                x: CGRectGetWidth(CGPathGetBoundingBox(outerRingShape.path))/2,
                y: CGRectGetHeight(CGPathGetBoundingBox(outerRingShape.path))/2)
            starShap.transform = CATransform3DIdentity
            starShap.opacity = 0.5
            self.layer.addSublayer(starShap)
        }
        
        
    }
    
    private func updateLayerProperties(){
        
        if fillRingShape != nil {
            fillRingShape.fillColor = favoriteColor.CGColor
        }
        
        if outerRingShape != nil {
            outerRingShape.lineWidth = lineWidth
            outerRingShape.strokeColor = notFavoriteColor.CGColor
        }
        
        if starShap != nil {
            starShap.fillColor = isFavorite ? starFavoriteColor.CGColor : notFavoriteColor.CGColor
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createLayersIfNeeded()
        updateConstraints()
    }
    
    private func prepareForFavorite() {
        
        executeWithoutActions {
            
        }
        

    }
    
    private func favorite(){
        //  1.Star
        var starGoUp = CATransform3DIdentity
        starGoUp = CATransform3DScale(starGoUp, 1.5, 1.5, 1.5)
        
        var starGoDown = CATransform3DIdentity
        starGoDown = CATransform3DScale(starGoDown, 0.01, 0.01, 0.01)
        
        let starKeyFrames = CAKeyframeAnimation(keyPath: "transform")
        starKeyFrames.values = [
            NSValue(CATransform3D: CATransform3DIdentity),
            NSValue(CATransform3D: starGoUp),
            NSValue(CATransform3D: starGoDown)
        ]
        starKeyFrames.keyTimes = [0.0, 0.4, 0.6]
        starKeyFrames.duration = 0.4
        starKeyFrames.beginTime = CACurrentMediaTime() + 0.05
        starKeyFrames.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        starKeyFrames.fillMode = kCAFillModeBackwards
        starKeyFrames.setValue(favoriteKey, forKey: startKey)
        
        starKeyFrames.delegate = self
        starShap.addAnimation(starKeyFrames, forKey: favoriteKey)
        starShap.transform = starGoDown
        
        //  2.Outer Circle
        var grayGoUp = CATransform3DIdentity
        grayGoUp = CATransform3DScale(grayGoUp, 1.5, 1.5, 1.5)
        
        var grayGoDown = CATransform3DIdentity
        grayGoDown = CATransform3DScale(grayGoDown, 0.01, 0.01, 0.01)
        
        let outerCircleAnimation = CAKeyframeAnimation(keyPath: "transform")
        outerCircleAnimation.values = [
            NSValue(CATransform3D:CATransform3DIdentity),
            NSValue(CATransform3D:grayGoUp),
            NSValue(CATransform3D:grayGoDown)
        ]
        outerCircleAnimation.keyTimes = [0.0, 0.4, 0.6]
        outerCircleAnimation.duration = 0.4
        outerCircleAnimation.beginTime = CACurrentMediaTime() + 0.01
        outerCircleAnimation.fillMode = kCAFillModeBackwards
        outerCircleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        outerRingShape.addAnimation(outerCircleAnimation, forKey: "Gray circle Animation")
        outerRingShape.transform = grayGoDown
        
        //  3.Fill Circle
        var favoriteFillGrow = CATransform3DIdentity
        favoriteFillGrow = CATransform3DScale(favoriteFillGrow, 1.5, 1.5, 1.5)
        
        let fillCircleAnimation = CAKeyframeAnimation(keyPath: "transform")
        fillCircleAnimation.values = [
            NSValue(CATransform3D:fillRingShape.transform),
            NSValue(CATransform3D:favoriteFillGrow),
            NSValue(CATransform3D:CATransform3DIdentity),
        ]
        fillCircleAnimation.keyTimes = [
            0.0,
            0.4,
            0.6,
        ]
        fillCircleAnimation.duration = 0.4
        fillCircleAnimation.beginTime = CACurrentMediaTime() + 0.22
        fillCircleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        fillCircleAnimation.fillMode = kCAFillModeBackwards
        
        let favoriteFillOpacity = CABasicAnimation(keyPath: "opacity")
        favoriteFillOpacity.toValue = 1
        favoriteFillOpacity.duration = 1
        favoriteFillOpacity.beginTime = CACurrentMediaTime()
        favoriteFillOpacity.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        favoriteFillOpacity.fillMode = kCAFillModeBackwards
        
        fillRingShape.addAnimation(fillCircleAnimation, forKey: "Show fill circle")
        fillRingShape.addAnimation(favoriteFillOpacity, forKey: "fill circle Animation")
        fillRingShape.transform = CATransform3DIdentity
    }
    
    private func endFavorite(){
        
        executeWithoutActions{
            self.starShap.fillColor = self.starFavoriteColor.CGColor
            self.starShap.opacity = 1
            self.fillRingShape.opacity = 1
            self.outerRingShape.transform = CATransform3DIdentity
            self.outerRingShape.opacity = 0
        }
        
        let starAnimations = CAAnimationGroup()
        var starGoUp = CATransform3DIdentity
        starGoUp = CATransform3DScale(starGoUp, 2, 2, 2)
        
        let starKeyFrames = CAKeyframeAnimation(keyPath: "transform")
        starKeyFrames.values = [
            NSValue(CATransform3D:starShap.transform),
            NSValue(CATransform3D:starGoUp),
            NSValue(CATransform3D:CATransform3DIdentity)
        ]
        starKeyFrames.keyTimes = [
            0.0,
            0.4,
            0.6
        ]
        starKeyFrames.duration = 0.2
        starKeyFrames.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        starShap.addAnimation(starKeyFrames, forKey: nil)
        starShap.transform = CATransform3DIdentity
    
    }
    
    private func notFavorite(){
        
        
        
    }
    
    private func frameWithInset() -> CGRect{
        return CGRectInset(self.bounds, lineWidth/2, lineWidth/2)
    }
    
    private func executeWithoutActions(closure: () -> ()) {

    }
    
}
