//
//  SlideOpenView.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/29.
//

import UIKit

class SlideOpenView: UIView {

    let backgroundView = UIView()
    let indicatorView = UIView()
    let textLabel = UILabel()
    public var sliderCornerRadius: CGFloat = 30.0 {
            didSet {
                backgroundView.layer.cornerRadius = sliderCornerRadius
                indicatorView.layer.cornerRadius = sliderCornerRadius - thumbnailViewStartingDistance
            }
        }
    private var panGestureRecognizer: UIPanGestureRecognizer!

    public var thumbnailViewStartingDistance: CGFloat = 0.0 {
        didSet {
            indicatorHeightAnchor?.constant = -thumbnailViewStartingDistance * 2
            indicatorLeadingAnchor?.constant =  thumbnailViewStartingDistance
            setNeedsLayout()
        }
    }

    private var xEndingPoint: CGFloat {
        return self.frame.width
    }

    private var initialWidth: CGFloat {
        return self.frame.width - self.frame.height
    }

    private var didSetup: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    private func setupView() {

        addSubview(backgroundView)

        backgroundView.addSubview(textLabel)
        backgroundView.addSubview(indicatorView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        indicatorView.addGestureRecognizer(panGestureRecognizer)

        backgroundView.backgroundColor = .blue
        indicatorView.backgroundColor = .lightGray

        backgroundView.clipsToBounds = true
        indicatorView.clipsToBounds = true
        backgroundView.layer.cornerRadius = sliderCornerRadius
        indicatorView.layer.cornerRadius = sliderCornerRadius - 3

    }

    var indicatorWidthAnchor: NSLayoutConstraint?
    var indicatorHeightAnchor: NSLayoutConstraint?
    var indicatorLeadingAnchor: NSLayoutConstraint?
    private func setupConstraints() {

        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        indicatorLeadingAnchor = indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: thumbnailViewStartingDistance)
        indicatorLeadingAnchor?.isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicatorHeightAnchor = indicatorView.heightAnchor.constraint(equalTo: heightAnchor, constant: -thumbnailViewStartingDistance)
        indicatorHeightAnchor?.isActive = true
        indicatorWidthAnchor = indicatorView.widthAnchor.constraint(equalTo: indicatorView.heightAnchor)
        indicatorWidthAnchor?.isActive = true

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {

        let translatedPoint = sender.translation(in: backgroundView).x

        switch sender.state {
        case .began:
            break
        case .changed:

            if translatedPoint  >= initialWidth {
                indicatorWidthAnchor?.constant = initialWidth
            } else if translatedPoint <= 0 {
                break
            } else {

                indicatorWidthAnchor?.constant = translatedPoint
            }

        case .ended:

            if translatedPoint >= (initialWidth / 2) {
                indicatorWidthAnchor?.constant = initialWidth
            } else {
                let const = indicatorHeightAnchor?.constant ?? 0
                let map = const + (thumbnailViewStartingDistance * 2)

                indicatorWidthAnchor?.constant = map
            }

            UIView.animate(withDuration: 0.1, delay: 0.1, options: [.curveEaseIn]) {
                self.layoutIfNeeded()
            } completion: { _ in

            }

        default:
            break
        }
    }
}
