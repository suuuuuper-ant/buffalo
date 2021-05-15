//
//  SignupEmailViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/14.
//

import UIKit

class SignupBaseViewController: UIViewController, ViewType {

    lazy var inputFieldView: UIStackView  = {
        let input = UIStackView()
        input.axis = .vertical
        input.spacing = 31
        return input
    }()

    var guide: String = "" {
        didSet {
            guideLabel.text = guide
        }
    }
    var buttonTitle: String = "" {
        didSet {
            nextButton.setTitle(buttonTitle, for: .normal)
        }
    }
    lazy var guideLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    lazy var nextButton: UIButton = {

        let next = UIButton()
        next.setTitleColor(.white, for: .normal)
        next.backgroundColor = AppColor.mainColor.color
        next.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        next.makeRounded(cornerRadius: 25)

        return next
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        view.backgroundColor = .white
        [guideLabel, inputFieldView, nextButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false

        }

    }

    func setupConstraint() {
        guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        inputFieldView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 74).isActive = true

        inputFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        inputFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.topAnchor.constraint(equalTo: inputFieldView.bottomAnchor, constant: 61).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

}

class SignupEmailViewController: SignupBaseViewController {

    lazy var emailField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_cancel"),
            placeholder: "이메일")
        let email = SignInputFieldView(viewModel)

        return email
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guide = "사용할\n이메일을 입력해주세요"
        buttonTitle = "다음"
        inputFieldView.addArrangedSubview(emailField)

        nextButton.addTarget(self, action: #selector(moveToPage), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    @objc func moveToPage() {
        if let pageController = parent as? SignupFlowViewController {
                pageController.pushNext()
            }
    }

}
