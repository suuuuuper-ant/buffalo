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
        setBackButton(color: AppColor.darkgray62.color)
        pwdButton.makeRounded(cornerRadius: 13)
        rightButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)

        nicknameTextField.text = nickname
        emailLabel.text = email

        let attributes = [NSAttributedString.Key.foregroundColor: AppColor.gray160.color,
                          .font: UIFont.systemFont(ofSize: 12, weight: .medium)]
        pwdTextField.attributedPlaceholder = NSAttributedString(string: "영문+숫자 6자리 이상 입력해 주세요", attributes: attributes)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: 커스텀 백버튼 설정
    private func setBackButton(color: UIColor) {

        //백버튼 이미지 파일 이름에 맞게 변경
        let backBtn = UIBarButtonItem(image: UIImage(named: "icon_navigation_back"),
            style: .plain,
            target: self,
            action: #selector(self.checkPop))

        backBtn.imageInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = backBtn
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }

    @objc func checkPop() {
        if pwdButton.tag == 1 && pwdTextField.text != "" {
            let vc = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(identifier: MyPagePopupViewController.reuseIdentifier) as MyPagePopupViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.popClosure = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            self.present(vc, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
        sender.tag = 1
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
