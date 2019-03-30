//
//  UIAnimatedPlayButton.swift
//  KMC-Player
//
//  Created by Nilit Danan on 3/21/18.
//  Copyright © 2018 Nilit Danan. All rights reserved.
//

import UIKit

enum UIAnimatedPlayButtonState {
    case Play
    case Pause
}

class UIAnimatedPlayButton: UIButton {

    private var currentButtonState: UIAnimatedPlayButtonState = .Play
    
    var currentState: UIAnimatedPlayButtonState {
        get {
            return self.currentButtonState
        }
        set {
            self.transformToState(newValue)
        }
    }
    
    private var topLayer: CAShapeLayer = CAShapeLayer()
    private var middleLayer: CAShapeLayer = CAShapeLayer()
    private var bottomLayer: CAShapeLayer = CAShapeLayer()
    
    private var lineWidth: CGFloat {
        return self.titleLabel?.font.pointSize ?? 7.0
    }
    private var lineLenght: CGFloat {
        return min(self.layer.frame.size.width, self.layer.frame.size.height) * 0.7
    }
    
    var lineColor: UIColor {
        return self.titleColor(for: UIControl.State.normal) ?? .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.updateAppearance()
    }
    
    func updateAppearance() {
        topLayer.removeFromSuperlayer()
        middleLayer.removeFromSuperlayer()
        bottomLayer.removeFromSuperlayer()
        
        let x = self.bounds.width / 2
        let heightDiff = self.lineLenght / 2
        var y = self.bounds.height / 2 - heightDiff
        
        topLayer = self.createLayer()
        topLayer.position = CGPoint(x: x, y: y)
        y += heightDiff
        
        middleLayer = self.createLayer()
        middleLayer.position = CGPoint(x: x, y: y)
        y += heightDiff
        
        bottomLayer = self.createLayer()
        bottomLayer.position = CGPoint(x: x, y: y)
        
        self.transformToState(currentState)
    }
    
    private func createLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: self.lineLenght, y: 0))
        
        layer.path = path.cgPath
        layer.lineWidth = self.lineWidth
        layer.strokeColor = self.lineColor.cgColor
        layer.lineCap = CAShapeLayerLineCap(rawValue: "round")
        
        let bound = CGPath(__byStroking: layer.path!, transform: nil, lineWidth: layer.lineWidth, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: layer.miterLimit)
        
        if let bounds = bound {
            layer.bounds = bounds.boundingBox
        }
        
        self.layer.addSublayer(layer)
        
        return layer
    }
    
    func transformToState(_ state: UIAnimatedPlayButtonState) {
        var transform: CATransform3D
        
        switch state {
        case .Play:
            transform = CATransform3DMakeTranslation((topLayer.position.x - self.lineLenght * 0.75 + self.lineWidth * 0.25),
                                                     (topLayer.position.y + self.lineLenght * 0.0 + self.lineWidth * 0.25),
                                                     0.0)
            transform = CATransform3DScale(transform, 1.0, 1.0, 1.0)
            topLayer.transform = CATransform3DRotate(transform, CGFloat(Double.pi/6), 0.0, 0.0, 1.0);
            
            
            transform = CATransform3DMakeTranslation((middleLayer.position.x - self.lineLenght * 1.25 + self.lineWidth * 0.5),
                                                     0.0,
                                                     0.0);
            transform = CATransform3DScale(transform, 1.0, 1.0, 1.0)
            middleLayer.transform = CATransform3DRotate(transform, CGFloat(Double.pi/2), 0.0, 0.0, 1.0);

            
            transform = CATransform3DMakeTranslation((bottomLayer.position.x - self.lineLenght * 0.75 + self.lineWidth * 0.25),
                                                     (bottomLayer.position.y - self.lineLenght * 1.5 + self.lineWidth * 0.25),
                                                     0.0);
            transform = CATransform3DScale(transform, 1.0, 1.0, 1.0)
            bottomLayer.transform = CATransform3DRotate(transform, CGFloat(-Double.pi/6), 0.0, 0.0, 1.0);
            
        case .Pause:
            transform = CATransform3DMakeTranslation((topLayer.position.x - self.lineLenght * 1.25 + self.lineWidth * 0.5),
                                                     (topLayer.position.y + self.lineLenght * 0.25 + self.lineWidth * 0.25),
                                                     0.0);
            transform = CATransform3DScale(transform, 1.0, 1.0, 1.0)
            topLayer.transform = CATransform3DRotate(transform, CGFloat(Double.pi/2), 0.0, 0.0, 1.0);
            
            // middleLayer doesn't need to change

            transform = CATransform3DMakeTranslation((bottomLayer.position.x - self.lineLenght * 0.5 + self.lineWidth * 0.5),
                                                     (bottomLayer.position.y - self.lineLenght * 1.75 + self.lineWidth * 0.25),
                                                     0.0);
            transform = CATransform3DScale(transform, 1.0, 1.0, 1.0)
            bottomLayer.transform = CATransform3DRotate(transform, CGFloat(-Double.pi/2), 0.0, 0.0, 1.0);
        }
        
        self.currentButtonState = state
    }
}
