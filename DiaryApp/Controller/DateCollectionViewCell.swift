//
//  DateCollectionViewCell.swift
//  DiaryApp
//
//  Created by Admin on 28.07.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var circle: UIView!
    
    
    func drawCircle() {
        let circleCenter = circle.center
        
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: (circle.bounds.width / 2 - 5), startAngle: -CGFloat.pi/2, endAngle: (2 * CGFloat.pi), clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 2
        circleLayer.strokeEnd = 0
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = CAShapeLayerLineCap.round
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        animation.toValue = 1
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        circleLayer.add(animation, forKey: nil)
        circle.layer.addSublayer(circleLayer)
        circle.layer.backgroundColor = UIColor.clear.cgColor
    }
    
}
