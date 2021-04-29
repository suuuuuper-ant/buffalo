//
//  SlideOpenView.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/29.
//

import UIKit

class SlideOpenView: UIView {

    let backgroundView: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.init(named: "main_color")
        return background
    }()

    let indicatorView: UIView = {
        let indicator = UIView()
        indicator.backgroundColor = UIColor.init(named: "pull_indicator")
        return indicator
    }()
    let textLabel: UILabel = {
       let label = UILabel()
        label.text = "밀어서 잠금해제"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    let showMeView: UIImageView = {
        let showMe = UIImageView()
        showMe.backgroundColor = .blue
        return showMe
    }()
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
        return self.frame.width - self.backgroundView.frame.height
    }

    private var didSetup: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    private func setupView() {

        addSubview(backgroundView)
        addSubview(showMeView)
        backgroundView.addSubview(textLabel)
        backgroundView.addSubview(indicatorView)
        showMeView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        indicatorView.addGestureRecognizer(panGestureRecognizer)

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
        backgroundView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        textLabel.fittingView(backgroundView)

        indicatorLeadingAnchor = indicatorView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: thumbnailViewStartingDistance)
        indicatorLeadingAnchor?.isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        indicatorHeightAnchor = indicatorView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, constant: -thumbnailViewStartingDistance)
        indicatorHeightAnchor?.isActive = true
        indicatorWidthAnchor = indicatorView.widthAnchor.constraint(equalTo: indicatorView.heightAnchor)
        indicatorWidthAnchor?.isActive = true

        showMeView.centerXAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: -20).isActive = true
        showMeView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -11).isActive = true
        showMeView.widthAnchor.constraint(equalToConstant: 87).isActive = true
        showMeView.heightAnchor.constraint(equalToConstant: 36).isActive = true

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
            let persent = (translatedPoint / initialWidth)
            print("\(persent)")
            self.textLabel.alpha = 1.0 - persent
            if translatedPoint  >= initialWidth {
                indicatorWidthAnchor?.constant = initialWidth
            } else if translatedPoint <= 0 {
                break
            } else {

                indicatorWidthAnchor?.constant = translatedPoint
            }

        case .ended:
            var persent: CGFloat = 0.0
            if translatedPoint >= (initialWidth / 2) {
                indicatorWidthAnchor?.constant = initialWidth

            } else {
                let const = indicatorHeightAnchor?.constant ?? 0
                let map = const + (thumbnailViewStartingDistance * 2)
                persent = 1.0
                indicatorWidthAnchor?.constant = map
            }

            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn]) {
                self.textLabel.alpha = persent
                self.layoutIfNeeded()
            } completion: { _ in

            }

        default:
            break
        }
    }
}
