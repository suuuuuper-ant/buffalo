//
//  HomeTitleHeaderView.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/19.
//

import UIKit

class HomeTitleHeaderView: UITableViewHeaderFooterView {
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "04.14"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    let greetingLabel: UILabel = {
        let greeting = UILabel()
        greeting.numberOfLines = 0
        greeting.text = "가니님,\n오늘도 함꼐 디긴해요!"
        greeting.font = UIFont.boldSystemFont(ofSize: 30)
        greeting.translatesAutoresizingMaskIntoConstraints = false
        return greeting
    }()

    let radomPickButton: UIButton = {
       let randomPick = UIButton()
        randomPick.setTitle("새로운 기업을 디긴해 볼까요?", for: .normal)
        randomPick.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        randomPick.layer.cornerRadius = 10
        randomPick.clipsToBounds = true
        randomPick.translatesAutoresizingMaskIntoConstraints = false
        randomPick.backgroundColor = .lightGray
        return randomPick
    }()

    var slideOpenView: SlideOpenView = {
        let slide = SlideOpenView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))

        slide.thumbnailViewStartingDistance = 6
        slide.sliderCornerRadius = 80 / 2
        return slide
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        self.backgroundView?.backgroundColor = .white
        addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true

        addSubview(greetingLabel)
        greetingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        greetingLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 50).isActive = true

        addSubview(slideOpenView)
        slideOpenView.translatesAutoresizingMaskIntoConstraints = false
        slideOpenView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        slideOpenView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        slideOpenView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        slideOpenView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true

    }

    fileprivate func addGradientMaskToView(view: UIView, transparency: CGFloat = 0.5, gradientWidth: CGFloat = 40.0) {
        let gradientMask = CAGradientLayer()
        gradientMask.frame = view.bounds
        let gradientSize = gradientWidth/view.frame.size.width
        let gradientColor = UIColor(white: 1, alpha: transparency)
        let startLocations = [0, gradientSize/2, gradientSize]
        let endLocations = [(1 - gradientSize), (1 - gradientSize/2), 1]
        let animation = CABasicAnimation(keyPath: "locations")

        gradientMask.colors = [gradientColor.cgColor, UIColor.white.cgColor, gradientColor.cgColor]
        gradientMask.locations = startLocations as [NSNumber]?
        gradientMask.startPoint = CGPoint(x: 0 - (gradientSize * 2), y: 0.5)
        gradientMask.endPoint = CGPoint(x: 1 + gradientSize, y: 0.5)

        view.layer.mask = gradientMask

        animation.fromValue = startLocations
        animation.toValue = endLocations
        animation.repeatCount = HUGE
        animation.duration = 3

        gradientMask.add(animation, forKey: nil)
    }

}

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
            get {
                return self.frame.width
            }
        }

    private var initialWidth: CGFloat {
        get {
            return self.frame.width - self.frame.height
        }
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

//        indicatorTrailingAnchor = indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
              //  thumbnailViewStartingDistance = translatedPoint
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

            break

        default:
            break
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        if !didSetup { indicatorTrailingAnchor?.constant = -(frame.width - frame.height)
//            didSetup = true
//        }

    }
}
