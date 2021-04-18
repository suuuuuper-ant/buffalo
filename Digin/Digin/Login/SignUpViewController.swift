//
//  SignViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

class SignUpViewController: UIViewController {

    let emailTextField: UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "input text.."
        return email
    }()

    let passwordTextField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.placeholder = "input password.."
        return password
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        view.addSubview(label)
        label.text = "\(String(describing: self))"
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 100)

        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true

        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true

        let button = UIButton(type: .custom)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50).isActive = true
        button.setTitle("signup", for: .normal)
        button.backgroundColor = .blue
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(signup), for: .touchUpInside)
    }

    @objc func signup() {

        let params = [
            "name": "sdsd",
            "email": "moo",
            "password": "yaho"
        ] as [String: Any]

        NetworkRouter.shared.post("http://3.35.143.195/auth/sign-up", body: params, headers: [], model: String.self) { (result) in
            switch result {
            case .success(let st):
                print("success")
            case .failure(let error):
                print(error.localizedDescription)

            }
        }
    }
}
