//
//  FaceView.swift
//  Happieness
//
//  Created by David Balcher on 6/12/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class FaceView: UIView {

    
    var lineWidth: CGFloat = 3 { didSet{ setNeedsDisplay() } }
    var faceScale: CGFloat = 0.9 { didSet{ setNeedsDisplay() } }
    var lineColor = UIColor.blueColor() { didSet{ setNeedsDisplay() } }
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var faceRadius: CGFloat {
        return min(superview!.frame.height, superview!.frame.width) * faceScale / 2
    }
    
    
    static struct Scaling {
        static let faceViewScaleToEyeViewScaleRatio: CGFloat = 3
        static let faceViewToEyeViewVirticalDisplacementRatio: CGFloat = 1.5
        static let faceViewToEyeViewHorizontalDisplacementRatio: CGFloat = 1.5
        
    
    }
    
    private enum Eye { case left, right }
    
    private func drawBezierPathForEyeBall(whichEye: Eye) -> UIBezierPath {
        let eyeCenter = faceCenter
        eyeCenter.y * Scaling.faceViewToEyeViewVirticalDisplacementRatio
        switch (whichEye) {
        case .left: eyeCenter.x /
        case .right: eyeCenter.x /
        default: break
        }
        
        let eyeRadius = faceRadius
        eyeRadius / Scaling.faceViewScaleToEyeViewScaleRatio
        
        
        
        let eyePath = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        eyePath.lineWidth = lineWidth
        return eyePath
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        lineColor.set()
        facePath.lineWidth = lineWidth
        facePath.stroke()
    }
    
    
}
