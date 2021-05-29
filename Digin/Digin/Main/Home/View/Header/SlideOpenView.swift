//
//  SlideOpenView.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/29.
//

import UIKit

class SlideOpenView: UIView {

    @Published var reachedEnd: Bool = false

    let slideFaceImageView: UIImageView = {
        let slideFace = UIImageView()
        let image = UIImage(named: "icon_slide_face")
        slideFace.image = image
        return slideFace
    }()

    let backgroundView: UIView = {
        let background = UIView()
        background.backgroundColor = UIColor.init(named: "main_color")
        return background
    }()

    let indicatorView: GradientView = {
        guard let start = UIColor.init(named: "slidebar_start_color"), let end = UIColor.init(named: "pull_indicator")  else {
            return GradientView(gradientStartColor: .purple, gradientEndColor: .purple)

        }

        return GradientView(gradientStartColor: start, gradientEndColor: end)
    }()
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 기업 밀어서 찾기"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()

    let showMeView: UIImageView = {
        let showMe = UIImageView()
        let image = UIImage(named: "icon_bubble_start")
        showMe.image = image
        return showMe
    }()

    let showMeEndView: UIImageView = {
        let showMe = UIImageView()
        let image = UIImage(named: "icon_bubble_end")
        showMe.image = image
        return showMe
    }()

    let showMeTitle: UILabel = {
        let showMeTitle = UILabel()
        showMeTitle.text = "Slide me"
        showMeTitle.textAlignment = .center
        showMeTitle.textColor = .blue
        showMeTitle.font = UIFont.englishFont(ofSize: 12)
        return showMeTitle
    }()

    let showMeEndTitle: UILabel = {
        let showMeTitle = UILabel()
        showMeTitle.text = "Good!"
        showMeTitle.textAlignment = .center
        showMeTitle.textColor = .blue
        showMeTitle.font = UIFont.englishFont(ofSize: 12)
        return showMeTitle
    }()

    public var sliderCornerRadius: CGFloat = 30.0 {
        didSet {
            backgroundView.layer.cornerRadius = sliderCornerRadius
            indicatorView.layer.cornerRadius = sliderCornerRadius - thumbnailViewStartingDistance
            indicatorView.gradient.cornerRadius = sliderCornerRadius - thumbnailViewStartingDistance
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let backBounds =  backgroundView.bounds
        indicatorView.gradient.frame = CGRect(origin: backBounds.origin, size: CGSize(width: backBounds.width - (thumbnailViewStartingDistance * 2), height: backBounds.height))

    }
    private func setupView() {

        [ backgroundView, showMeView, showMeEndView, slideFaceImageView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        showMeView.addSubview(showMeTitle)
        showMeEndView.addSubview(showMeEndTitle)
        backgroundView.addSubview(textLabel)
        backgroundView.addSubview(indicatorView)

        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        showMeTitle.translatesAutoresizingMaskIntoConstraints = false
        showMeEndTitle.translatesAutoresizingMaskIntoConstraints = false

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        indicatorView.addGestureRecognizer(panGestureRecognizer)

        backgroundView.clipsToBounds = true
        indicatorView.clipsToBounds = true
        backgroundView.layer.cornerRadius = sliderCornerRadius
        showMeEndView.isHidden = true
        indicatorView.flatColor()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func resetIndicator() {
        let const = indicatorHeightAnchor?.constant ?? 0
        let map = const + (thumbnailViewStartingDistance * 2)
        indicatorWidthAnchor?.constant = map
        switchToBubleView(end: false)
        indicatorView.flatColor()
        self.textLabel.alpha = 1.0

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
        showMeTitle.leadingAnchor.constraint(equalTo: showMeView.leadingAnchor, constant: 16).isActive = true
        showMeTitle.trailingAnchor.constraint(equalTo: showMeView.trailingAnchor, constant: -16).isActive = true
        showMeTitle.topAnchor.constraint(equalTo: showMeView.topAnchor, constant: 6).isActive = true
        showMeTitle.bottomAnchor.constraint(equalTo: showMeView.bottomAnchor, constant: -11).isActive = true

        showMeEndView.leadingAnchor.constraint(equalTo: showMeView.leadingAnchor).isActive = true
        showMeEndView.bottomAnchor.constraint(equalTo: showMeView.bottomAnchor).isActive = true

        showMeEndTitle.leadingAnchor.constraint(equalTo: showMeEndView.leadingAnchor, constant: 16).isActive = true
        showMeEndTitle.trailingAnchor.constraint(equalTo: showMeEndView.trailingAnchor, constant: -16).isActive = true
        showMeEndTitle.topAnchor.constraint(equalTo: showMeEndView.topAnchor, constant: 6).isActive = true
        showMeEndTitle.bottomAnchor.constraint(equalTo: showMeEndView.bottomAnchor, constant: -11).isActive = true

        slideFaceImageView.trailingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: -17).isActive = true
        slideFaceImageView.topAnchor.constraint(equalTo: indicatorView.topAnchor, constant: 13).isActive = true
        slideFaceImageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        slideFaceImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {

        let translatedPoint = sender.translation(in: backgroundView).x
        var isEnd = false
        switch sender.state {
        case .began:
            break
        case .changed:

            let persent = (translatedPoint / initialWidth)

            self.textLabel.alpha = 1.0 - persent
            if translatedPoint  >= initialWidth {
                indicatorWidthAnchor?.constant = initialWidth
                isEnd = true
                switchToBubleView(end: isEnd)

            } else if translatedPoint <= 0 {
                indicatorView.flatColor()
                break
            } else {
                isEnd = false
                switchToBubleView(end: isEnd)
                indicatorWidthAnchor?.constant = translatedPoint
            }
            indicatorView.gradientColor()

        case .ended:
            var persent: CGFloat = 0.0
            if translatedPoint >= (initialWidth / 2) {
                indicatorWidthAnchor?.constant = initialWidth
                isEnd = true
                switchToBubleView(end: isEnd)

                persent = 1.0
                self.textLabel.alpha = persent
            } else {
                let const = indicatorHeightAnchor?.constant ?? 0
                let map = const + (thumbnailViewStartingDistance * 2)
                persent = 1.0
                indicatorWidthAnchor?.constant = map
                isEnd = false
                switchToBubleView(end: isEnd)
                indicatorView.flatColor()
            }

            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn]) {
                self.textLabel.alpha = persent
                self.layoutIfNeeded()
            } completion: { _ in
                if isEnd {
                    self.reachedEnd = true
                }

            }

        default:
            break
        }
    }

    private func switchToBubleView(end: Bool) {

        if end {
            showMeView.isHidden = true
            showMeEndView.isHidden = false
        } else {
            showMeView.isHidden = false
            showMeEndView.isHidden = true
        }
    }
}
