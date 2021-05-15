//
//  SignupPasswordViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/15.
//

import UIKit

class SignupPasswordViewController: SignupBaseViewController {

    lazy var passwordField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_password"),
            placeholder: "비밀번호")
        let password = SignInputFieldView(viewModel)

        return password
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guide = "사용할\n비밀번호를 입력해주세요"
        buttonTitle = "다음"
        inputFieldView.addArrangedSubview(passwordField)
        passwordField.textField.isSecureTextEntry = true

        nextButton.addTarget(self, action: #selector(moveToPage), for: .touchUpInside)
        // Do any additional setup after loading the view.

    }

    @objc func moveToPage() {
        if let pageController = parent as? SignupFlowViewController {
                pageController.pushNext()
            }
    }

}
