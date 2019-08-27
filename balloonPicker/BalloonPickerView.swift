//
//  BaloonPickerView.swift
//  balloonPicker
//
//  Created by Anton Skopin on 05/06/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

public protocol ProgressTracking {
    func update(value: Double, minValue: Double, maxValue: Double)
}

public typealias ProgressTrackingView = UIView & ProgressTracking

@IBDesignable open class BalloonPickerView: UIControl {

    open override var tintColor: UIColor! {
        didSet {
            trackLayer.leftColor = tintColor
            trackLayer.setNeedsDisplay()
            thumb.tintColor = tintColor
            baloonView.tintColor = tintColor
        }
    }

    open var lineColor: UIColor! = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.9294117647, alpha: 1) {
        didSet {
            trackLayer.rightColor = lineColor
            trackLayer.setNeedsDisplay()
        }
    }

    @IBInspectable public var minimumValue: Double = 1.0 {
        didSet {
            if minimumValue > maximumValue {
                maximumValue = minimumValue
            }
            _value = max(minimumValue, _value)
        }
    }

    @IBInspectable public var maximumValue: Double = 99.0 {
        didSet {
            if maximumValue < minimumValue  {
                minimumValue = maximumValue
            }
            _value = min(maximumValue, _value)
        }
    }

    private var _value: Double = 0.0

    @IBInspectable public var value: Double {
        get {
            return _value
        }
        set {
            _value = max(minimumValue, min(maximumValue, newValue))
            baloonView.update(value: _value, minValue: minimumValue, maxValue: maximumValue)
        }
    }

    open var thumbSize: CGFloat = 40.0 {
        didSet {
            trackLayer.margin = thumbSize/2.0
            invalidateIntrinsicContentSize()
        }
    }

    open var baloonSize: CGSize {
        return baloonView.intrinsicContentSize
    }

    open var ropeLength: CGFloat = 90

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: thumbSize * 6, height: thumbSize + 2)
    }

    open var baloonView: ProgressTrackingView = BalloonView() {
        didSet {
            baloonView.tintColor = tintColor
            baloonView.isUserInteractionEnabled = false
            oldValue.removeFromSuperview()
            addSubview(baloonView)
        }
    }

    private var scaleDuration: TimeInterval = 0.2

    private lazy var displayLink: CADisplayLink = CADisplayLink(target: self, selector: #selector(screenUpdate))

    private var moving: Bool = false

    private lazy var thumb = ThumbView()

    private var trackLayer = TrackLayer()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    open override func prepareForInterfaceBuilder() {
        configure()
        screenUpdate()
        updateTrackLayer()
    }

    private func configure() {
        thumb.tintColor = tintColor
        trackLayer.leftColor = tintColor
        trackLayer.rightColor = lineColor
        thumb.isUserInteractionEnabled = false
        baloonView.isUserInteractionEnabled = false
        layer.addSublayer(trackLayer)
        addSubview(thumb)
        addSubview(baloonView)
        thumb.frame = CGRect(x: 0, y: (bounds.height - thumbSize) / 2.0,
                                  width: thumbSize, height: thumbSize)
        baloonView.frame = CGRect(origin: .zero,
                              size: baloonSize)
        baloonView.layer.transform = CATransform3DMakeScale(0, 0, 1)
        displayLink.add(to: .current, forMode: .common)
        trackLayer.margin = thumbSize/2.0
    }

    private var previousLocation = CGPoint()
    private var startDragTime: TimeInterval = 0
    private var endDragTime: TimeInterval = 0

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        let location = touch.location(in: self)
        if thumb.frame.contains(location) {
            baloonView.frame = CGRect(origin: CGPoint(x: thumb.frame.midX - baloonSize.width/2.0,
                                                  y: baloonView.frame.minY),
                                  size: baloonSize)
            moving = true
            startDragTime = CACurrentMediaTime()
        }
        return moving
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbSize * 2)
        previousLocation = location
        if moving {
            value = max(minimumValue, min(maximumValue, value + deltaValue))
        }

        sendActions(for: .valueChanged)
        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        moving = false
        endDragTime = CACurrentMediaTime()
    }

    private var thumbOffset: CGFloat {
        return (bounds.width - thumbSize) * CGFloat((value - minimumValue) / (maximumValue - minimumValue))
    }

    private var prevOffset: CGFloat = 0
    @objc private func screenUpdate() {
        thumb.frame = CGRect(x: thumbOffset,
                             y: (bounds.height - thumbSize)/2.0,
                             width: thumbSize, height: thumbSize)
        var coeff: CGFloat
        if moving {
            coeff = CGFloat(min(1.0, (CACurrentMediaTime() - startDragTime)/scaleDuration))
        } else {
            coeff = CGFloat(max(0.0, 1 - (CACurrentMediaTime() - endDragTime)/scaleDuration))
        }
        let dist = coeff * ropeLength
        let targetOffset = thumb.frame.midX
        let diff = thumb.frame.midX - baloonView.frame.midX

        var baloonHorOffset = prevOffset + diff/10.0
        if diff > 0 {
            baloonHorOffset = min(baloonHorOffset, targetOffset)
        } else {
            baloonHorOffset = max(baloonHorOffset, targetOffset)
        }

        prevOffset = baloonHorOffset
        let baloonVertOffset = dist
        let angle: CGFloat = abs(diff) > 0.001 ? -atan(diff/baloonVertOffset) : 0
        thumb.configure(with: coeff)

        baloonView.layer.transform = CATransform3DIdentity
        
        baloonView.frame = CGRect(origin: CGPoint(x: baloonHorOffset - baloonSize.width/2.0,
                                              y: bounds.midY - baloonSize.height/2.0 - baloonVertOffset),
                              size: baloonSize)
        if coeff > 0.001 {
            baloonView.isHidden = false
            baloonView.layer.transform = CATransform3DScale(CATransform3DMakeRotation(angle, 0, 0, 1), coeff, coeff, 1.0)
        } else {
            baloonView.isHidden = true
        }
        updateTrackLayer()

    }

    private func updateTrackLayer() {
        trackLayer.frame = bounds
        trackLayer.valueOffset = thumb.frame.minX
        trackLayer.redraw()
    }
}

extension CGFloat {
    var floatSign: CGFloat {
        return self >= 0 ? 1 : -1
    }
}
