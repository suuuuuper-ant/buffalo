//
//  LoginViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

class LoginViewController: UIViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        let label = UILabel()
        view.addSubview(label)
        label.text = "\(String(describing: self))"
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        view.addSubview(loginButton)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50).isActive = true
        loginButton.addTarget(self, action: #selector(goToMain), for: .touchUpInside)
        view.addSubview(signUpButton)
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 50).isActive = true
        signUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
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
