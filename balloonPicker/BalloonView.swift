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
    }

    override open var intrinsicContentSize: CGSize {
        if imageView.image != nil {
            return imageView.intrinsicContentSize
        } else {
            return CGSize(width: defaultSize, height: defaultSize)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        label.sizeToFit()
        label.frame = CGRect(x: (bounds.width - label.frame.width)/2.0,
                             y: 16,
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

    open func update(value: Double) {
        label.text = "\(Int(value))"
        layoutSubviews()
    }
}

