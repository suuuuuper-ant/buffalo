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

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        setBackBtn(color: AppColor.darkgray62.color)
        pwdButton.makeRounded(cornerRadius: 13)
        rightButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)

    }

    @IBAction func saveAction(_ sender: UIBarButtonItem) {

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
