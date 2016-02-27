//
//  CircularLoaderView.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 27/02/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

@IBDesignable
class CircularLoaderView: UIView {
    let circlePathLayer = CAShapeLayer()
    let circlePathUpperLayer = CAShapeLayer()
    
    @IBInspectable var fillColor:UIColor = UIColor.greenColor()
    
    @IBInspectable var borderColor:UIColor = UIColor.blackColor()
    
    @IBInspectable var circleRadius:CGFloat = 90.0
    
    
    var progress: CGFloat {
        get {
            return circlePathUpperLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathUpperLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathUpperLayer.strokeEnd = 0
            } else {
                circlePathUpperLayer.strokeEnd = newValue
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        borderColor.setFill()
        
        configure(circlePathLayer, layerColor: borderColor.CGColor)
        
        configure(circlePathUpperLayer, layerColor: fillColor.CGColor)
    }
    
    func configure(circleLayer: CAShapeLayer, layerColor: CGColor) {
        circleLayer.frame = bounds
        circleLayer.lineWidth = 4
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = layerColor
        layer.addSublayer(circleLayer)
        backgroundColor = UIColor.whiteColor()
        
        circleLayer.frame = bounds
        circleLayer.path = circlePath().CGPath
        progress = 0
        
        animateProgressView()
    }
    
    func animateProgressView() {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(0.75)
        animation.duration = 1.0
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = true
        animation.fillMode = kCAFillModeForwards
        circlePathUpperLayer.addAnimation(animation, forKey: "strokeEnd")
    }
    
    
    func circlePath() -> UIBezierPath {
        
        /*draw  circle*/
        let bezierPath = UIBezierPath(arcCenter:CGPointMake( CGRectGetMidX(circlePathLayer.bounds),  CGRectGetMidY(circlePathLayer.bounds)), radius: circleRadius, startAngle: CGFloat(M_PI_2) * 3.0, endAngle:CGFloat(M_PI_2) * 3.0 + CGFloat(M_PI) * 2.0, clockwise: true)
        
        return bezierPath
    }
    
}
