//
//  EditMyDataViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/27.
//

import UIKit

class EditMyDataViewController: UIViewController {

    @IBOutlet weak var rightButton: UIBarButtonItem!

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pwdTextField: UITextField!

    @IBOutlet weak var pwdButton: UIButton!

    var nickname = ""
    var email = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        setBackBtn(color: AppColor.darkgray62.color)
        pwdButton.makeRounded(cornerRadius: 13)
        rightButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)

        nicknameTextField.text = nickname
        emailLabel.text = email

        let attributes = [NSAttributedString.Key.foregroundColor: AppColor.gray160.color,
                          .font: UIFont.systemFont(ofSize: 12, weight: .medium)]
        pwdTextField.attributedPlaceholder = NSAttributedString(string: "영문+숫자 6자리 이상 입력해 주세요",
                                                                   attributes: attributes)
    }

    @IBAction func saveAction(_ sender: UIBarButtonItem) {

    }

    @IBAction func hiddenButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if sender.isSelected {
            pwdTextField.isSecureTextEntry = true
        } else {
            pwdTextField.isSecureTextEntry = false
        }
    }

    @IBAction func editPwdAction(_ sender: UIButton) {

    }

    @IBAction func logoutAction(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "token")
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }

    @IBAction func withdrawalAction(_ sender: UIButton) {
    }
}
