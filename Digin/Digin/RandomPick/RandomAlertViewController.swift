//
//  RandomAlertViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/25.
//

import UIKit
import Combine

class RandomAlertViewController: UIViewController, ViewType {
    var parentController: UIViewController?
    var cancellables: Set<AnyCancellable> = []

    lazy  var alertView: UIView = {
        let alert = UIView()
        alert.makeRounded(cornerRadius: 20)
        alert.backgroundColor = .white
        return alert
    }()

    lazy var alertIconImageView: UIImageView = {
       let icon = UIImageView()
        icon.image = UIImage(named: "random_alert")
        return icon
    }()

    lazy var titleLabel: UILabel = {
       let title = UILabel()
        title.text = "그대로 나가시겠어요?"
        title.textColor = AppColor.darkgray62.color
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return title
    }()

    lazy var descriptionLabel: UILabel = {
       let description = UILabel()
        description.text = "랜덤 추천 기업은\n하루에 딱 한 번만 볼 수 있어요."
        description.textColor = AppColor.darkgray82.color
        description.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        description.numberOfLines = 2
        return description
    }()

    lazy var exitButton: UIButton = {
        let exit = UIButton()
        exit.setTitle("나가기", for: .normal)
        exit.setTitleColor(AppColor.gray160.color, for: .normal)
        exit.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return exit
    }()

    lazy var detailButton: UIButton = {
        let detail = UIButton()
        detail.setTitle("기업 확인하기", for: .normal)
        detail.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        detail.setTitleColor(AppColor.mainColor.color, for: .normal)
        return detail
    }()

    lazy var buttonStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.addArrangedSubview(exitButton)
        stack.addArrangedSubview(detailButton)

        return stack
    }()

    lazy var separateLineView: UIView = {
        let separate = UIView()
        separate.backgroundColor = AppColor.lightgray225.color
        return separate
    }()
    // 프레젠트 애니메이션에 사용
    var alertViewBottomConstraint: NSLayoutConstraint?

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

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        alertViewBottomConstraint?.constant = -310 - 301

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func setupUI() {
        view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        [alertIconImageView, titleLabel, descriptionLabel, separateLineView, buttonStack].forEach {
            alertView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

    }

    func setupConstraint() {
        // alertView
        alertViewBottomConstraint = alertView.topAnchor.constraint(equalTo: view.bottomAnchor)
        alertViewBottomConstraint?.isActive = true
        alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        alertView.widthAnchor.constraint(equalToConstant: 290).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 310).isActive = true

        // alertIconImageView
        alertIconImageView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        alertIconImageView.widthAnchor.constraint(equalToConstant: 122).isActive = true
        alertIconImageView.heightAnchor.constraint(equalToConstant: 122).isActive = true
        alertIconImageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20).isActive = true

        // titleLabel
        titleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: alertIconImageView.bottomAnchor, constant: 20).isActive = true

        // descriptionLabel
        descriptionLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true

        // separateLineView
        separateLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separateLineView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        separateLineView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        separateLineView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor).isActive = true

        // buttonStack
        buttonStack.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

    func bindingUI() {

        exitButton.tapPublisher.sink { [unowned self] _ in
          let vc = self.parentController as? RandomPickViewController

            self.alertViewBottomConstraint?.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn]) {
                self.view.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.dismiss(animated: false)
                vc?.navigationController?.popViewController(animated: true)
            }

        }.store(in: &cancellables)

        detailButton.tapPublisher.sink { [unowned self] _ in
            let vc = self.parentController as? RandomPickViewController
            self.alertViewBottomConstraint?.constant = 0
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn]) {
                self.view.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.dismiss(animated: false)
                vc?.goToDetail()
            }
        }.store(in: &cancellables)

    }

    deinit {
        print("deinit randomAlert")
    }

}
