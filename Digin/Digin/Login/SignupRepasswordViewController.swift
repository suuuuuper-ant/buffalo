//
//  SignupRepasswordViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/15.
//

import UIKit
import Combine

class SignupRepasswordViewController: SignupBaseViewController {

    lazy var viewModel: SingupRePasswordViewModel = {
        let viewModel = SingupRePasswordViewModel()

        return viewModel
    }()

    lazy var passwordField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_password"),
            placeholder: "비밀번호")

        let password = SignInputFieldView(viewModel)

        password.descriptionLabel.text = "영문 + 숫자 6자리 입력해 주세요."
        password.descriptionLabel.textColor = AppColor.gray183.color
        password.textField.isUserInteractionEnabled =  false
        return password
    }()

    lazy var rePasswordField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_password"),
            placeholder: "비밀번호 확인")
        let password = SignInputFieldView(viewModel)
        password.descriptionLabel.text = "비밀번호를 다시 한번 입력해 주세요."
        password.descriptionLabel.textColor = AppColor.gray183.color

        return password
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guide = "비밀번호를\n다시 한 번 입력해주세요"
        buttonTitle = "다음"
        inputFieldView.addArrangedSubview(passwordField)
        inputFieldView.addArrangedSubview(rePasswordField)
        passwordField.textField.isSecureTextEntry = true
        rePasswordField.textField.isSecureTextEntry = true

        changeNextButton(false)

        bindingUI()
        bindingViewModel()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pageController = parent as? SignupFlowViewController {
            self.viewModel.flowViewController = pageController
            self.passwordField.textField.text = pageController.temporaryUserInfo.password
        }

    }

    func bindingUI() {

       rePasswordField.textField.textPublisher.sink { [unowned self] text in
            if let text = text {
                self.viewModel.rePassword.send(text)
            }
        }.store(in: &cancellables)

        passwordField.textFieldButton.tapPublisher.sink { [unowned self] _ in
            self.changePasswordCharacterHidden(inputField: passwordField)
        }.store(in: &cancellables)

        rePasswordField.textFieldButton.tapPublisher.sink { [unowned self] _ in
            self.changePasswordCharacterHidden(inputField: rePasswordField)
        }.store(in: &cancellables)

        nextButton.tapPublisher.sink { [unowned self] _ in
            self.moveToPage()
        }.store(in: &cancellables)

    }

    func bindingViewModel() {

        viewModel.passwordValidation.sink { _ in
        } receiveValue: { [unowned self] message in
            self.rePasswordField.descriptionLabel.text = message
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

    func moveToPage() {
        if let pageController = parent as? SignupFlowViewController {
                pageController.pushNext()
            }
    }

    private func changeNextButton( _ activation: Bool) {

        nextButton.backgroundColor = activation ? AppColor.mainColor.color : AppColor.gray183.color
        nextButton.isEnabled =  activation ? true : false

    }

    private func changePasswordDescription(_ isValid: Bool) {

        rePasswordField.descriptionLabel.textColor = isValid ? AppColor.mainColor.color : AppColor.stockRed.color

    }

    private func changePasswordCharacterHidden(inputField: SignInputFieldView) {

        inputField.textField.isSecureTextEntry = !inputField.textField.isSecureTextEntry

        if  inputField.textField.isSecureTextEntry {
            inputField.textFieldButton.setImage(UIImage(named: "signup_password"), for: .normal)

        } else {
            inputField.textFieldButton.setImage(UIImage(named: "signup_password_active"), for: .normal)
        }

    }

}
