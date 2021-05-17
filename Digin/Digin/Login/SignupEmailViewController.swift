//
//  SignupEmailViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/14.
//

import UIKit
import Combine

class SignupBaseViewController: UIViewController, ViewType {
    var cancellables: Set<AnyCancellable> = []

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

    var viewModel = SingupEmailViewModel()

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
        changeNextButton(false)
        bindingUI()
        bindingViewModel()
    }

    func bindingUI() {

        emailField.textField.textPublisher.sink { [unowned self] text in
            if let text = text {
                self.viewModel.email.send(text)
            }
        }.store(in: &cancellables)

        emailField.textFieldButton.tapPublisher.sink { [unowned self] _ in
            self.emailField.textField.text = ""
            self.emailField.descriptionLabel.text = ""
            self.changeNextButton(false)
        }.store(in: &cancellables)

        emailField.textField.didBeginEditingPublisher.sink { [unowned self] _ in
            self.emailField.lineView.backgroundColor = AppColor.mainColor.color
        }.store(in: &cancellables)

        emailField.textField.didEndEditingPublisher.sink { [unowned self] _ in
            self.emailField.lineView.backgroundColor = AppColor.gray160.color
        }.store(in: &cancellables)
    }

    func bindingViewModel() {

        viewModel.emailValidation.sink { _ in
        } receiveValue: { [unowned self] message in
            self.emailField.descriptionLabel.text = message

        }.store(in: &cancellables)

        viewModel.nextButtonValidation.sink { _ in
        } receiveValue: { [unowned self] nextEnable  in
            self.changeNextButton(nextEnable)
        }.store(in: &cancellables)

    }

    private func changeNextButton( _ activation: Bool) {

        nextButton.backgroundColor = activation ? AppColor.mainColor.color : AppColor.gray183.color
        nextButton.isEnabled =  activation ? true : false

    }

    @objc func moveToPage() {
        if let pageController = parent as? SignupFlowViewController {
            pageController.temporaryUserInfo.email = emailField.textField.text
            pageController.pushNext()
        }
    }

}
