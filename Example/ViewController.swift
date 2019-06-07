//
//  ViewController.swift
//  balloonPicker
//
//  Created by Anton Skopin on 05/06/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var picker: BalloonPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let str = NSAttributedString(string: "Choose\nballoon\nquantity",
                                     attributes: [.font: UIFont.systemFont(ofSize: 45, weight: .semibold),
                                                  .foregroundColor:  UIColor.black,
                                                  .kern: -0.96])
        let balloonView = BalloonView()
        balloonView.image = #imageLiteral(resourceName: "balloon")
        lblTop.attributedText = str
        picker.baloonView = balloonView
        picker.value = 30
        picker.tintColor = #colorLiteral(red: 0.3568627451, green: 0.2156862745, blue: 0.7176470588, alpha: 1)
        valueChanged()
    }
     

    @IBAction func valueChanged() {
        lblQuantity.text = "\(Int(picker.value))"
    }


}

