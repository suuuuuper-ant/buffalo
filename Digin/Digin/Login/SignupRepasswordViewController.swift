//
//  SignupRepasswordViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/15.
//

import UIKit

class SignupRepasswordViewController: SignupBaseViewController {

    lazy var passwordField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_password"),
            placeholder: "비밀번호")
        let password = SignInputFieldView(viewModel)

        return password
    }()

    lazy var rePasswordField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_password"),
            placeholder: "비밀번호 확인")
        let password = SignInputFieldView(viewModel)

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

        nextButton.addTarget(self, action: #selector(moveToPage), for: .touchUpInside)
        // Do any additional setup after loading the view.

    }

    @objc func moveToPage() {
        if let pageController = parent as? SignupFlowViewController {
                pageController.pushNext()
            }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
