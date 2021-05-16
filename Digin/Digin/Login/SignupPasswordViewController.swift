//
//  SignupPasswordViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/15.
//

import UIKit

class SignupPasswordViewController: SignupBaseViewController {

    var viewModel = SingupPasswordViewModel()

    lazy var passwordField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_password"),
            placeholder: "비밀번호")
        let password = SignInputFieldView(viewModel)
        password.descriptionLabel.text = "영문 + 숫자 6자리 입력해 주세요."
        password.descriptionLabel.textColor = AppColor.homeBackground.color
        return password
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guide = "사용할\n비밀번호를 입력해주세요"
        buttonTitle = "다음"
        inputFieldView.addArrangedSubview(passwordField)
        passwordField.textField.isSecureTextEntry = true

        nextButton.addTarget(self, action: #selector(moveToPage), for: .touchUpInside)
        changeNextButton(false)

        bindingUI()
        bindingViewModel()

    }

    func bindingUI() {

        passwordField.textField.textPublisher.sink { [unowned self] text in
            if let text = text {
                self.viewModel.password.send(text)
            }
        }.store(in: &cancellables)

        passwordField.textFieldButton.tapPublisher.sink { [unowned self] _ in
            self.changePasswordCharacterHidden(!passwordField.textField.isSecureTextEntry)
        }.store(in: &cancellables)

    }

    func bindingViewModel() {

        viewModel.passwordValidation.sink { _ in
        } receiveValue: { [unowned self] message in
            self.passwordField.descriptionLabel.text = message
        }.store(in: &cancellables)

        viewModel.nextButtonValidation.sink { _ in
        } receiveValue: { [unowned self] nextEnable  in
            self.changeNextButton(nextEnable)
        }.store(in: &cancellables)

        viewModel.passwordDescriptionColor.sink { _ in
        } receiveValue: { [unowned self] isValid  in
            self.changePasswordDescription(isValid)
        }.store(in: &cancellables)

    }

    @objc func moveToPage() {
        if let pageController = parent as? SignupFlowViewController {
                pageController.pushNext()
            }
    }

    private func changeNextButton( _ activation: Bool) {

        nextButton.backgroundColor = activation ? AppColor.mainColor.color : AppColor.homeBackground.color
        nextButton.isEnabled =  activation ? true : false

    }

    private func changePasswordDescription(_ isValid: Bool) {

        passwordField.descriptionLabel.textColor = isValid ? AppColor.homeBackground.color : AppColor.stockRed.color

    }

    
    private func changePasswordCharacterHidden(_ isHidden: Bool) {
        passwordField.textField.isSecureTextEntry = isHidden
       
        if  passwordField.textField.isSecureTextEntry  {
            passwordField.textFieldButton.setImage(UIImage(named: "signup_password"), for: .normal)
            
        } else {
            passwordField.textFieldButton.setImage(UIImage(named: "signup_password_active"), for: .normal)
        }

    }
}
