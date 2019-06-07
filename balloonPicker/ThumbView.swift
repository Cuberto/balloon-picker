//
//  ThumbView.swift
//  balloonPicker
//
//  Created by Anton Skopin on 06/06/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class ThumbView: UIView {

    let innerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    open override var tintColor: UIColor! {
        didSet {
            bgView.backgroundColor = tintColor
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        clipsToBounds = true
        addSubview(bgView)
        addSubview(innerView)
        bgView.backgroundColor = tintColor
        configure(with: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        innerView.frame = CGRect(x: (bounds.width - innerView.frame.width) / 2,
                                 y: (bounds.height - innerView.frame.height) / 2,
                                 width: innerView.frame.width,
                                 height: innerView.frame.height)
    }

    func configure(with progress: CGFloat) {
        let fixedProgress = min(1, max(0, progress))


        let bgSize: CGFloat  = bounds.width * 0.7 + bounds.width * 0.3 * fixedProgress

        let innerSize: CGFloat = bounds.width / 3.0 + ( 2 * bounds.width / 3.0 - 2.0) * fixedProgress

        bgView.layer.cornerRadius = (0.8 + 0.2 * fixedProgress) * bgSize / 2.0

        bgView.frame = CGRect(x: (bounds.width - bgSize) / 2,
                            y: (bounds.height - bgSize) / 2,
                                 width: bgSize,
                                 height: bgSize)

        innerView.frame = CGRect(x: (bounds.width - innerSize) / 2,
                                 y: (bounds.height - innerSize) / 2,
                                 width: innerSize,
                                 height: innerSize)
        innerView.layer.cornerRadius = innerSize / 2.0
    }
}
