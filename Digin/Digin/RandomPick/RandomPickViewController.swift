//
//  RandomPickViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/24.
//

import UIKit
import Combine

class RandomPickViewController: UIViewController, ViewType {
    var cancellables: Set<AnyCancellable> = []

    lazy var backgroundLeftImageView: UIImageView = {
        let leftImage = UIImageView()
        leftImage.image = UIImage(named: "randompick_bg_left")
        leftImage.contentMode = .scaleAspectFill
        return leftImage

    }()

    lazy var backgroundRightImageView: UIImageView = {
        let rightImage = UIImageView()
        rightImage.image = UIImage(named: "randompick_bg_right")
        rightImage.contentMode = .scaleAspectFill
        return rightImage

    }()

    lazy var backButton: UIButton = {
        let back = UIButton()
        back.setImage(UIImage(named: "icon_navigation_back_white"), for: .normal)
        return back
    }()

    lazy var cardView: UIView = {
        let card = UIView()
        card.layer.cornerRadius = 20
        card.layer.masksToBounds = true
        return card
    }()

    lazy var cardFrontView: UIButton = {
        let cardFront = UIButton()
        cardFront.setImage(UIImage(named: "randompick_digincard"), for: .normal)

        return cardFront
    }()

    lazy var frontBottomLabel: UILabel = {
        let frontBottom = UILabel()
        frontBottom.text = "카드를 눌러서\n오늘의 추천 기업을 확인해 보세요."
        frontBottom.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        frontBottom.textColor = AppColor.gray225.color
        frontBottom.numberOfLines = 0
        frontBottom.textAlignment = .center

        return frontBottom
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
        setupUI()
        setupConstraint()
        bindingUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = AppColor.dark24.color

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = AppColor.dark24.color
        self.navigationController?.navigationBar.tintColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let barbutton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItems = [barbutton]

    }

    func setupUI() {
        [backgroundLeftImageView, backgroundRightImageView, cardView, frontBottomLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [cardFrontView].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

    }

    func setupConstraint() {
        // backbutton
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
//

        // letftImage

        backgroundLeftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundLeftImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -24).isActive = true
        backgroundLeftImageView.widthAnchor.constraint(equalToConstant: 108).isActive = true
        backgroundLeftImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -95).isActive = true

        //rightImage
        backgroundRightImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundRightImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundRightImageView.widthAnchor.constraint(equalToConstant: 139).isActive = true
        backgroundRightImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 112).isActive = true

        // cardView
        cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: 310).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 435).isActive = true

        // cardFrontView
        cardFrontView.fittingView(cardView)

        //frontBottomLabel
        frontBottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frontBottomLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 46).isActive = true

    }

    func bindingUI() {

        cardFrontView.tapPublisher.receive(on: DispatchQueue.main).sink { [unowned self] in
            UIView.transition(with: cardView, duration: 1.0, options: .transitionFlipFromLeft, animations: nil, completion: nil)

        }.store(in: &cancellables)

        backButton.tapPublisher.sink {  [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
    }
}
