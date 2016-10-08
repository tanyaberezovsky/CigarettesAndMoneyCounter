//
//  CircularLoaderView.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 27/02/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

//@IBDesignable
class CircularLoaderView: UIView , CAAnimationDelegate{
    let circlePathLayer = CAShapeLayer()
    let circlePathUpperLayer = CAShapeLayer()
    
    @IBInspectable var fillColor:UIColor = UIColor.green
    
    @IBInspectable var borderColor:UIColor = UIColor.black
    
    @IBInspectable var circleRadius:CGFloat = 90.0

    @IBInspectable var toValue:CGFloat = 50.0

    
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
    
    override func draw(_ rect: CGRect) {
        borderColor.setFill()
        
        circleRadius = self.frame.height / 2
        
        configure(circlePathLayer, layerColor: borderColor.cgColor)
        
        configure(circlePathUpperLayer, layerColor: fillColor.cgColor)
        
        self.backgroundColor = UIColor.clear
    }
    
    func configure(_ circleLayer: CAShapeLayer, layerColor: CGColor) {
        circleLayer.frame = bounds
        circleLayer.lineWidth = 4
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = layerColor
        layer.addSublayer(circleLayer)
        backgroundColor = UIColor.white
        
        circleLayer.frame = bounds
        circleLayer.path = circlePath().cgPath
        progress = 0
        
        animateProgressView()
    }
    
    func animateProgressView() {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(toValue / 100)
        animation.duration = 0.5
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = kCAFillModeForwards
        circlePathUpperLayer.add(animation, forKey: "strokeEnd")
    }
    
    
    func circlePath() -> UIBezierPath {
        
        /*draw  circle*/
        let bezierPath = UIBezierPath(arcCenter:CGPoint( x: circlePathLayer.bounds.midX,  y: circlePathLayer.bounds.midY), radius: circleRadius, startAngle: CGFloat(M_PI_2) * 3.0, endAngle:CGFloat(M_PI_2) * 3.0 + CGFloat(M_PI) * 2.0, clockwise: true)
        
        return bezierPath
    }
    
}
