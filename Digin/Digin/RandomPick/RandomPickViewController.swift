//
//  RandomPickViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/24.
//

import UIKit
import Combine

struct RandomPick {
    var name: String
    var category: String
}

class RandomPickViewController: UIViewController, ViewType {
    var isflip: Bool = false

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

    lazy var cardBackViewTopLabel: UILabel = {
        let  cardBackView = UILabel()
        cardBackView.text = "오늘의 새로운 기업을\n 디긴하셨네요!"
        cardBackView.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        cardBackView.textColor = UIColor.white
        cardBackView.numberOfLines = 0
        cardBackView.textAlignment = .center

        return  cardBackView
    }()

    lazy var cardBackView: CardBackView = {
        let card = CardBackView()
        card.categoryLabel.text = ""
        card.companyLabel.text =  ""

        return card
    }()

    lazy var likeButton: UIButton = {
        let like = UIButton()
        like.setImage(UIImage(named: "icon_like_empty"), for: .normal)

        return like
    }()

    lazy var likeCountLabel: UILabel = {
        let likeCount = UILabel()
        likeCount.text = "10"
        likeCount.textColor = .white
        likeCount.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        return likeCount
    }()

    lazy var likeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 7
        stack.addArrangedSubview(likeButton)
        stack.addArrangedSubview(likeCountLabel)

        return stack
    }()

    lazy var detailButton: UIButton = {
        let detail = UIButton()
        detail.setImage(UIImage(named: "icon_next_circle"), for: .normal)

        return detail
    }()

    lazy var detailLabel: UILabel = {
        let likeCount = UILabel()
        likeCount.text = "기업이 더 궁금해요!"
        likeCount.textColor = AppColor.lightgray225.color
        likeCount.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        return likeCount
    }()

    lazy var detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 6
        stack.addArrangedSubview(detailLabel)
        stack.addArrangedSubview(detailButton)

        return stack
    }()

    var randomData: [RandomPick] = [
        //RandomPick(name: "카카오뱅크", category: "금융"),
                                   // RandomPick(name: "SK바이오로직스", category: "바이오 생명"),
                                    RandomPick(name: "네이버", category: "")
//                                    RandomPick(name: "현대자동차", category: "자동차"),
//                                    RandomPick(name: "삼성전자", category: "반도체")

    ]

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

        self.view.backgroundColor = AppColor.dark22.color

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.tintColor = .clear
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }

    func setupUI() {
        [ backgroundLeftImageView, backgroundRightImageView, cardView, frontBottomLabel, cardBackViewTopLabel, likeStack, detailStack, backButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [cardBackView ].forEach {
            cardView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        cardBackView.addSubview(cardFrontView)
        cardFrontView.translatesAutoresizingMaskIntoConstraints = false

        cardBackViewTopLabel.alpha = 0.0
        likeStack.alpha = 0.0
        detailStack.alpha = 0.0

    }

    func setupConstraint() {
        // backbutton
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        //

        // letftImage

        backgroundLeftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundLeftImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
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
        cardView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 375).isActive = true

        // cardFrontView
        cardBackView.fittingView(cardView)
        cardFrontView.fittingView(cardBackView)

        //cardBackViewTopLabel
        cardBackViewTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardBackViewTopLabel.bottomAnchor.constraint(equalTo: cardView.topAnchor, constant: -36).isActive = true

        //frontBottomLabel
        frontBottomLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frontBottomLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 46).isActive = true

        //likeStack
        likeStack.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 30).isActive = true
        likeStack.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true

        //detailStack
        detailStack.topAnchor.constraint(equalTo: likeStack.bottomAnchor, constant: 23).isActive = true
        detailStack.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true

    }

    func bindingUI() {

        cardFrontView.tapPublisher.receive(on: DispatchQueue.main).sink { [unowned self] in
            self.isflip = true
            let randomPickIndex = Int(arc4random_uniform(UInt32(self.randomData.count)))

            let pickData = self.randomData[randomPickIndex]
            self.cardBackView.configureCardContent(pickData)
            UIView.transition(with: cardView, duration: 1.0, options: .transitionFlipFromLeft) {
                cardBackViewTopLabel.alpha = 1.0
                likeStack.alpha = 1.0
                detailStack.alpha = 1.0
                frontBottomLabel.isHidden = true
                self.cardFrontView.isHidden = true

            } completion: { _ in
                self.cardFrontView.isHidden = true
            }

        }.store(in: &cancellables)

        backButton.tapPublisher.sink { [unowned self] in
            if self.isflip == true {
                showRandomAlert()
            } else {
                self.navigationController?.popViewController(animated: true)
            }

        }.store(in: &cancellables)

        detailButton.tapPublisher.sink { [unowned self] in

            self.goToDetail()
        }.store(in: &cancellables)
    }

    func showRandomAlert() {
        let alert = RandomAlertViewController()
        alert.parentController = self
        alert.modalPresentationStyle = .overCurrentContext
        self.present(alert, animated: false, completion: nil)
    }

    func goToDetail() {
        let detail = HomeDetailViewController(companyInfo: HomeUpdatedCompany(company: HomeCompanyInfo(id: 035420), consensusList: [], newsList: []))
        self.navigationController?.pushViewController(detail, animated: true)
        self.isflip = false
    }
}

class CardBackView: UIView, ViewType {

    let leftTopImageView: UIImageView = {

        let leftTop = UIImageView()
        leftTop.image = UIImage(named: "random_nocomment _up")
        return leftTop
    }()

    let rightBottomImageView: UIImageView = {

        let rightBottom = UIImageView()
        rightBottom.image = UIImage(named: "random_nocomment_down")
        return rightBottom
    }()

    lazy var companyImageView: UIImageView = {
        let companyImage = UIImageView()
        companyImage.makeRounded(cornerRadius: 94 / 2)
        companyImage.backgroundColor = UIColor.gray
        return companyImage
    }()

    lazy var companyLabel: UILabel = {
        let company = UILabel()
        company.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        company.numberOfLines = 2
        company.textAlignment = .center
        return company
    }()

    lazy var categoryLabel: PaddingLabel = {
        let company = PaddingLabel()
        company.edgeInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        company.makeRounded(cornerRadius: 15)
        company.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        company.makeBorder(color: .black, width: 1)
        return company
    }()

    lazy var companyStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        stack.addArrangedSubview(companyImageView)
        stack.addArrangedSubview(companyLabel)
        return stack
    }()

    lazy var cardStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.addArrangedSubview(companyStackView)
        stack.addArrangedSubview(categoryLabel)
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        backgroundColor = .white
        [leftTopImageView, rightBottomImageView, cardStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }

    func setupConstraint() {

        leftTopImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        leftTopImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        leftTopImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        leftTopImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        rightBottomImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        rightBottomImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        rightBottomImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        rightBottomImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true

        cardStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cardStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        cardStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true

        companyImageView.widthAnchor.constraint(equalToConstant: 94).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 94).isActive = true

    }

    func configureCardContent(_ model: RandomPick) {
        if model.category != "" {
            self.categoryLabel.text = model.category
        } else {
            categoryLabel.removeFromSuperview()
        }

        self.companyLabel.text = model.name

        self.companyImageView.kf.setImage(with: URL(string: "https://www.le-blanc.co.kr/wp-content/uploads/2018/09/naver.png"))
    }

}
