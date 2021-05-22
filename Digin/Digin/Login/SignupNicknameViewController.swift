//
//  SignupNicknameViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/15.
//

import UIKit
import Combine

class SignupNicknameViewController: SignupBaseViewController {

    var viewModel = SingupNicknameViewModel()

    lazy var nicknameField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_cancel"),
            placeholder: "닉네임")
        let nickname = SignInputFieldView(viewModel)

        return nickname
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guide = "사용할\n닉네임을 입력해주세요"
        buttonTitle = "다음"
        inputFieldView.addArrangedSubview(nicknameField)

        nextButton.addTarget(self, action: #selector(moveToPage), for: .touchUpInside)
        changeNextButton(false)

        bindingUI()
        bindingViewModel()
    }

    func bindingUI() {

        nicknameField.textField.textPublisher.sink { [unowned self] text in
            if let text = text {
                self.viewModel.nickname.send(text)
            }
        }.store(in: &cancellables)

        nicknameField.textFieldButton.tapPublisher.sink { [unowned self] _ in
            self.nicknameField.textField.text = ""
            self.nicknameField.descriptionLabel.text = ""
            self.changeNextButton(false)
        }.store(in: &cancellables)

        nicknameField.textField.didBeginEditingPublisher.sink { [unowned self] _ in
            self.nicknameField.lineView.backgroundColor = AppColor.mainColor.color
        }.store(in: &cancellables)

        nicknameField.textField.didEndEditingPublisher.sink { [unowned self] _ in
            self.nicknameField.lineView.backgroundColor = AppColor.gray160.color
        }.store(in: &cancellables)

        cancelButton.tapPublisher.sink { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }.store(in: &cancellables)

        previousButton.tapPublisher.sink { [unowned self] _ in
            self.moveToPrevious()
        }.store(in: &cancellables)
    }

    func bindingViewModel() {

        viewModel.nicknameValidation.sink { _ in
        } receiveValue: { [unowned self] message in
            self.nicknameField.descriptionLabel.text = message

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
            pageController.temporaryUserInfo.name = nicknameField.textField.text
            pageController.pushNext()
        }
    }

    @objc func moveToPrevious() {
        if let pageController = parent as? SignupFlowViewController {
            pageController.pushPrevious()
        }
    }
}
