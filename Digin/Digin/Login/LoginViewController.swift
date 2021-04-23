//
//  LoginViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

class LoginViewController: UIViewController {

    var isNOl = false
    let loginButton: UIButton = {
        let login = UIButton(type: .custom)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.setTitle("LOGIN", for: .normal)

        return login
    }()

    let signUpButton: UIButton = {
        let signup = UIButton(type: .custom)
        signup.translatesAutoresizingMaskIntoConstraints = false
        signup.setTitle("SIGNUP", for: .normal)
        return signup
    }()

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
        view.backgroundColor = .gray
        let label = UILabel()
        view.addSubview(label)
        label.text = "\(String(describing: self))"
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 100)

        //id
        view.addSubview(emailTextField)
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true

        //password
        view.addSubview(passwordTextField)
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20).isActive = true

        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50).isActive = true
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        view.addSubview(signUpButton)
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 50).isActive = true
        signUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
    }

    @objc func signIn() {

        let params = [
            "email": "mooyaho",
            "password": "mooyaho"
        ] as [String: Any]

        NetworkRouter.shared.post("http://3.35.143.195/auth/sign-in", body: params, headers: []) { (result) in
            switch result {
            case .success(let token):
                UserDefaults.standard.setValue(token, forKey: "userToken")
                DispatchQueue.main.async { [weak self] in
                    self?.goToMain()
                }

            case .failure(let error):
                print(error.localizedDescription)

            }
        }

    }

    @objc func goToMain() {
        let mainTabBar = MainTabBarController()
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate: SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sceneDelegate.window?.rootViewController = mainTabBar
        }
    }
    @objc func goToSignUp() {
        let signUp = SignUpViewController()
        signUp.modalPresentationStyle = .popover
        self.present(signUp, animated: true)
    }
    deinit {
       print("\(String(describing: self))")
    }
}
