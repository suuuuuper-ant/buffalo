//
//  LoginViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit
import Combine

class LoginViewController: UIViewController, ViewType {
    var viewModel: LoginViewModel = LoginViewModel()
    var cancellables: Set<AnyCancellable> = []
    lazy var emailField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 16, weight: .medium),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: nil,
            placeholder: "이메일")
        let email = SignInputFieldView(viewModel)

        return email
    }()

    lazy var passwordField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(font: UIFont.systemFont(ofSize: 16, weight: .medium), lineColor: AppColor.mainColor.color, leftButtonImage: nil, placeholder: "비밀번호")
        let password = SignInputFieldView(viewModel)

        return password
    }()

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

    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()

    let passwordSearchButton: UIButton = {
        let passwordSearch = UIButton(type: .custom)
        passwordSearch.translatesAutoresizingMaskIntoConstraints = false
        passwordSearch.setTitleColor(AppColor.gray183.color, for: .normal)
        passwordSearch.setTitle("비밀번호 찾기", for: .normal)
        passwordSearch.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return passwordSearch
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
        bindingViewModel()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    func bindingViewModel() {
        // input
        emailField.textField.textPublisher.sink { [unowned self] text in
            if let text = text {
                self.viewModel.email.send(text)
            }
        }.store(in: &cancellables)

        passwordField.textField.textPublisher.sink { [unowned self] text in
            if let text = text {
                self.viewModel.password.send(text)
            }
        }.store(in: &cancellables)

        emailField.textField.didBeginEditingPublisher.sink { [unowned self] _ in
            self.emailField.lineView.backgroundColor = AppColor.mainColor.color
        }.store(in: &cancellables)

        emailField.textField.didEndEditingPublisher.sink { [unowned self] _ in
            self.emailField.lineView.backgroundColor = AppColor.gray160.color
        }.store(in: &cancellables)

        passwordField.textField.didBeginEditingPublisher.sink { [unowned self] _ in
            self.passwordField.lineView.backgroundColor = AppColor.mainColor.color
        }.store(in: &cancellables)

        passwordField.textField.didEndEditingPublisher.sink { [unowned self] _ in
            self.passwordField.lineView.backgroundColor = AppColor.gray160.color
        }.store(in: &cancellables)

        passwordSearchButton.tapPublisher.sink { [unowned self] in
            self.goToSearchPassword()
        }.store(in: &cancellables)

        //output
        viewModel.emailValidation.sink { _ in

        } receiveValue: {  [unowned self] message in
            self.emailField.descriptionLabel.text = message
        }.store(in: &cancellables)

        viewModel.passwordValidation.sink { _ in
        } receiveValue: {  [unowned self] message in
            self.passwordField.descriptionLabel.text = message
        }.store(in: &cancellables)

    }

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        [greetingLabel, emailField, passwordField, loginButton, signUpButton, topImageView, passwordSearchButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

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

      //  let emailStack = emailArea()

        emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        emailField.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 55).isActive = true

        //password

        passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20).isActive = true

        loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 62).isActive = true
        loginButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)

        signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
        signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25).isActive = true
        signUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)

        passwordSearchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        passwordSearchButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor).isActive = true
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

    func goToSignupFlow() {
        let flow = SignupFlowViewController()
        flow.modalPresentationStyle = .fullScreen
        self.present(flow, animated: true, completion: nil)

    }

    func goToSearchPassword() {
        let flow = SearchPasswordViewController()
        flow.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(flow, animated: true)

    }

    @objc func goToSignUp() {

        let signUp = TermsAndConditionsViewController()
        signUp.parentVC = self

        let navi = UINavigationController(rootViewController: signUp)
        navi.modalPresentationStyle = .overCurrentContext
        self.present(navi, animated: false)
    }

    deinit {
        print("\(String(describing: self))")
    }
}
