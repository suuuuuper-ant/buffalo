//
//  SearchPasswordViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/19.
//

import UIKit

class SearchPasswordViewController: SignupBaseViewController {

    var viewModel = SearchPasswordViewModel()
    lazy var emailField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_cancel"),
            placeholder: "이메일")
        let email = SignInputFieldView(viewModel)

        return email
    }()

    lazy var emailSendedLabel: UILabel = {
       let email = UILabel()
        email.text = "이메일로 임시 비밀번호를 보내드렸어요!"

        email.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        email.textColor = AppColor.mainColor.color
        email.isHidden = true
        return email
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guide = "가입한 이메일을 입력하면\n임시 비밀번호를 보내드려요"
        buttonTitle = "임시 비밀번호 받기"
        inputFieldView.addArrangedSubview(emailField)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        previousButton.isHidden = true
        updateNextButton(false)
        bindingUI()
        bindingViewModel()

    }

    override func setupUI() {
        super.setupUI()
        view.addSubview(emailSendedLabel)
        emailSendedLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setupConstraint() {
        super.setupConstraint()
        emailSendedLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 25).isActive = true
        emailSendedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

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
            self.updateNextButton(false)
        }.store(in: &cancellables)

        emailField.textField.didBeginEditingPublisher.sink { [unowned self] _ in
            self.emailField.lineView.backgroundColor = AppColor.mainColor.color
        }.store(in: &cancellables)

        emailField.textField.didEndEditingPublisher.sink { [unowned self] _ in
            self.emailField.lineView.backgroundColor = AppColor.gray160.color
        }.store(in: &cancellables)

        nextButton.tapPublisher.sink { [unowned self] _ in
            // 임시비밀번호 콜
            self.emailSendedLabel.isHidden = false
        }.store(in: &cancellables)

        cancelButton.tapPublisher.sink { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }.store(in: &cancellables)
    }

    func bindingViewModel() {

        viewModel.emailValidation.sink { _ in
        } receiveValue: { [unowned self] message in
            self.emailField.descriptionLabel.text = message

        }.store(in: &cancellables)

        viewModel.nextButtonValidation.sink { _ in
        } receiveValue: { [unowned self] nextEnable  in
            self.updateNextButton(nextEnable)
        }.store(in: &cancellables)

    }

    private func updateNextButton( _ activation: Bool) {

        nextButton.backgroundColor = activation ? AppColor.mainColor.color : AppColor.gray183.color
        nextButton.isEnabled =  activation ? true : false

    }

    private func updateSendedLabel() {

    }

}
