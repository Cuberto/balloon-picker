//
//  BaloonView.swift
//  balloonPicker
//
//  Created by Anton Skopin on 05/06/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

open class BalloonView: ProgressTrackingView {

    open var defaultSize: CGFloat = 60

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    public let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .white
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    public var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            didUpdateTintColor()
        }
    }

    private func configure() {
        addSubview(imageView)
        addSubview(label)
        didUpdateTintColor()
        clipsToBounds = false
    }

    override open var intrinsicContentSize: CGSize {
        if imageView.image != nil {
            return imageView.intrinsicContentSize
        } else {
            return CGSize(width: defaultSize, height: defaultSize)
        }
    }

    private let defaultLabelOffset: CGFloat = 16
    override open func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: bounds.width * (1 - scaleFactor)/2.0, y: bounds.height * (1 - scaleFactor),
         width: bounds.width * scaleFactor, height: bounds.height * scaleFactor)
        label.sizeToFit()
        label.frame = CGRect(x: (bounds.width - label.frame.width)/2.0,
                             y:  bounds.height - imageView.frame.height *   (defaultSize - defaultLabelOffset)/defaultSize,
                             width: label.frame.width,
                             height: label.frame.height)
        if imageView.image == nil {
            layer.cornerRadius = defaultSize/2.0
        } else {
            layer.cornerRadius = 0
        }
    }

    override open var tintColor: UIColor! {
        didSet {
            didUpdateTintColor()
        }
    }

    private func didUpdateTintColor() {
        if imageView.image == nil {
            backgroundColor = tintColor
        } else {
            imageView.tintColor = tintColor
            backgroundColor = .clear
        }
    }

    private var scaleFactor: CGFloat = 1.0
    var minScale: CGFloat = 0.8
    var maxScale: CGFloat = 1.3

    open func update(value: Double, minValue: Double, maxValue: Double) {
        label.text = "\(Int(value))"
        scaleFactor = minScale + (maxScale - minScale) * CGFloat(value / (maxValue - minValue))
        layoutSubviews()
    }
}

