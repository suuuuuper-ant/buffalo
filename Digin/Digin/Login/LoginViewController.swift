//
//  LoginViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

class LoginViewController: UIViewController, ViewType {

    var isNOl = false
    let loginButton: UIButton = {
        let login = UIButton(type: .custom)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.setTitle("로그인", for: .normal)
        login.backgroundColor = AppColor.mainColor.color
        login.layer.cornerRadius = 25
        login.layer.masksToBounds = true
        login.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        return login
    }()

    let signUpButton: UIButton = {
        let signup = UIButton(type: .custom)
        signup.translatesAutoresizingMaskIntoConstraints = false
        signup.setTitleColor(AppColor.mainColor.color, for: .normal)
        signup.setTitle("간편하게 회원가입하기", for: .normal)
        signup.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return signup
    }()

   lazy var emailTextField: UITextField = {
        let email = UITextField()
        email.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        email.isUserInteractionEnabled = true
        email.delegate = self
        email.placeholder = "이메일"

        return email
    }()

    lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        password.placeholder = "비밀번호"
        password.isSecureTextEntry = true
        password.delegate = self
        return password
    }()

    lazy var topImageView: UIImageView = {
        let top = UIImageView()
        top.image = UIImage(named: "login_top")
        top.contentMode = .scaleAspectFit
        return top

    }()

    lazy var greetingLabel: UILabel = {
       let greeting = UILabel()
        greeting.text = "투자 정보의 시작,\n함께 디긴하러 가요!"
        greeting.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        greeting.numberOfLines = 0
        return greeting
    }()

    lazy var emailDescriptionLabel: UILabel = {
       let emailDescription = UILabel()
        emailDescription.text = "투자 정보의 시작,\n함께 디긴하러 가요!"
        emailDescription.textColor = AppColor.stockRed.color
        emailDescription.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        return emailDescription
    }()

    lazy var passwordDescriptionLabel: UILabel = {
       let emailDescription = UILabel()
        emailDescription.text = "투자 정보의 시작,\n함께 디긴하러 가요!"
        emailDescription.textColor = AppColor.stockRed.color
        emailDescription.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        return emailDescription
    }()

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()

    lazy var contentView: UIView = {

       return UIView()
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        [greetingLabel, passwordTextField, loginButton, signUpButton, topImageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func emailArea() -> UIStackView {
        let emailStack = UIStackView()
        emailStack.isUserInteractionEnabled = true

        emailStack.axis = .vertical
        contentView.addSubview(emailStack)
        let line = UIView()
        line.backgroundColor = AppColor.mainColor.color
        line.translatesAutoresizingMaskIntoConstraints = false
        emailStack.translatesAutoresizingMaskIntoConstraints = false
        emailStack.addArrangedSubview(emailTextField)
        emailStack.addArrangedSubview(line)
        emailStack.addArrangedSubview(emailDescriptionLabel)

        emailStack.spacing = 6
        emailStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        emailStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        emailStack.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 55).isActive = true

        //line
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return emailStack
    }

    func passwordArea() -> UIStackView {
        let passwordStack = UIStackView()
        passwordStack.axis = .vertical
        contentView.addSubview(passwordStack)
        let line = UIView()
        line.backgroundColor = AppColor.mainColor.color
        line.translatesAutoresizingMaskIntoConstraints = false
        passwordStack.translatesAutoresizingMaskIntoConstraints = false
        passwordStack.addArrangedSubview(passwordTextField)
        passwordStack.addArrangedSubview(line)
        passwordStack.addArrangedSubview(passwordDescriptionLabel)

        passwordStack.spacing = 6

        //line
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return passwordStack
    }

//    func loginArea() -> UIView {
//        let buttonB
//    }

    func setupConstraint() {

        scrollView.fittingView(view)
        contentView.fittingView(scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let contentViewHeght = contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        contentViewHeght.priority = .defaultLow
        contentViewHeght.isActive = true
        //topImage캐릭터
        topImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topImageView.heightAnchor.constraint(equalTo: topImageView.widthAnchor, multiplier: 165 / 375).isActive = true

        //인사말 레이블
        greetingLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 41).isActive = true
        greetingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true

        let emailStack = emailArea()

        //password

        let passwordStack = passwordArea()
        passwordStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        passwordStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        passwordStack.topAnchor.constraint(equalTo: emailStack.bottomAnchor, constant: 20).isActive = true

        loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordStack.bottomAnchor, constant: 62).isActive = true
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)

        signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
        signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25).isActive = true
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

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ sender: UITextField) -> Bool {
        sender.resignFirstResponder()

    }

}
