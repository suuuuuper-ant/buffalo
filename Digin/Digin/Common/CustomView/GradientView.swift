//
//  GradientView.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/04.
//

import UIKit

class GradientView: UIView {

    let gradient: CAGradientLayer = CAGradientLayer()
    private let gradientStartColor: UIColor
    private let gradientEndColor: UIColor

    init(gradientStartColor: UIColor, gradientEndColor: UIColor) {
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override var frame: CGRect {
        didSet {
           setNeedsLayout()
        }
    }
    override public func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradient.masksToBounds = true
        layer.masksToBounds = true
        gradient.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }

    private func refreshGradientLayer() {
        gradient.frame = bounds
    }

     func flatColor() {
        gradient.locations = [1]
    }
     func gradientColor() {
        gradient.locations = [0.1]
    }
}
