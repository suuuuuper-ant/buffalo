//
//  RoundShadowView.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/29.
//

import UIKit

class RoundShadowView: UIView {

    let containerView = UIView()
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 16.0
    private var fillColor: UIColor = .white
    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layoutView() {

        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10.0

        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()

            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor

            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 5

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
