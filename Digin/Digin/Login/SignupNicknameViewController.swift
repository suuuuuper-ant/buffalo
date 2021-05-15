//
//  SignupNicknameViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/15.
//

import UIKit

class SignupNicknameViewController: SignupBaseViewController {

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
        // Do any additional setup after loading the view.
    }

    @objc func moveToPage() {
        if let pageController = parent as? SignupFlowViewController {
                pageController.pushNext()
            }
    }
}
