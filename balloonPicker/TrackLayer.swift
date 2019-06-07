//
//  TrackLayer.swift
//  balloonPicker
//
//  Created by Anton Skopin on 05/06/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class TrackLayer: CALayer {

    var margin: CGFloat = 0
    var leftColor: UIColor = .blue {
        didSet {
            firstSegment.strokeColor = leftColor.cgColor
        }
    }
    var rightColor: UIColor = .lightGray {
        didSet {
            secondSegment.strokeColor = rightColor.cgColor
        }
    }

    var valueOffset: CGFloat = 0

    lazy var firstSegment: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = leftColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1.0
        self.addSublayer(layer)
        return layer
    }()

    lazy var secondSegment: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = rightColor.cgColor
        layer.fillColor = nil
        layer.lineWidth = 2.0
        self.addSublayer(layer)
        return layer
    }()

    func redraw() {
        firstSegment.frame = self.bounds
        secondSegment.frame = self.bounds

        let pt1 = CGPoint(x: margin, y: bounds.midY)
        let pt2 = CGPoint(x: margin + valueOffset, y: bounds.midY)
        let pt3 = CGPoint(x: bounds.maxX - margin, y: bounds.midY)

        let firstPath = UIBezierPath()
        let secondPath = UIBezierPath()
        firstPath.move(to: pt1)
        firstPath.addLine(to: pt2)
        secondPath.move(to: pt2)
        secondPath.addLine(to: pt3)

        firstSegment.path = firstPath.cgPath
        secondSegment.path = secondPath.cgPath
    }
}
