//
//  SignupEmailViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/14.
//

import UIKit
import Combine

class SignupBaseViewController: UIViewController, ViewType {
    var cancellables: Set<AnyCancellable> = []

    lazy var inputFieldView: UIStackView  = {
        let input = UIStackView()
        input.axis = .vertical
        input.spacing = 31
        return input
    }()

    var guide: String = "" {
        didSet {
            guideLabel.text = guide
        }
    }
    var buttonTitle: String = "" {
        didSet {
            nextButton.setTitle(buttonTitle, for: .normal)
        }
    }
    lazy var guideLabel: UILabel = {

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    lazy var nextButton: UIButton = {

        let next = UIButton()
        next.setTitleColor(.white, for: .normal)
        next.backgroundColor = AppColor.mainColor.color
        next.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        next.makeRounded(cornerRadius: 25)

        return next
    }()

    lazy var previousButton: UIButton = {

        let previous = UIButton()
        previous.setImage( UIImage(named: "icon_navigation_back"), for: .normal)
        return previous
    }()

    lazy var cancelButton: UIButton = {

        let cancel = UIButton()
        cancel.setImage( UIImage(named: "icon_cancel"), for: .normal)
        return cancel
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        view.backgroundColor = .white
        [guideLabel, inputFieldView, nextButton, previousButton, cancelButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false

        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let pageController = parent as? SignupFlowViewController {
            if   pageController.getCurrentIndex() == 0 {
                previousButton.isHidden = true
            }
        }
    }
    func setupConstraint() {
        guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        inputFieldView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 74).isActive = true

        inputFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        inputFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nextButton.topAnchor.constraint(equalTo: inputFieldView.bottomAnchor, constant: 61).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        previousButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        previousButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant: 24).isActive = true

        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 24).isActive = true

    }

}

class SignupEmailViewController: SignupBaseViewController {

    var viewModel = SingupEmailViewModel()

    lazy var emailField: SignInputFieldView = {
        let viewModel = SignInputFieldViewModel(
            font: UIFont.systemFont(ofSize: 20, weight: .bold),
            lineColor: AppColor.mainColor.color,
            leftButtonImage: UIImage(named: "signup_cancel"),
            placeholder: "이메일")
        let email = SignInputFieldView(viewModel)

        return email
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guide = "사용할\n이메일을 입력해주세요"
        buttonTitle = "다음"
        inputFieldView.addArrangedSubview(emailField)

        changeNextButton(false)
        bindingUI()
        bindingViewModel()
    }

    func bindingUI() {

        nextButton.tapPublisher.sink { [unowned self] in
            self.viewModel.checkEmailRepetion.send()
        }.store(in: &cancellables)

        emailField.textField.textPublisher.sink { [unowned self] text in
            if let text = text {
                self.viewModel.email.send(text)
            }
        }.store(in: &cancellables)

        emailField.textFieldButton.tapPublisher.sink { [unowned self] _ in
            self.emailField.textField.text = ""
            self.emailField.descriptionLabel.text = ""
            self.changeNextButton(false)
        }.store(in: &cancellables)

        emailField.textField.didBeginEditingPublisher.sink { [unowned self] _ in
            self.emailField.lineView.backgroundColor = AppColor.mainColor.color
        }.store(in: &cancellables)

        emailField.textField.didEndEditingPublisher.sink { [unowned self] _ in
            self.emailField.lineView.backgroundColor = AppColor.gray160.color
        }.store(in: &cancellables)

        cancelButton.tapPublisher.sink { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }.store(in: &cancellables)

        previousButton.tapPublisher.sink { [unowned self] _ in
            self.moveToPrevious()
        }.store(in: &cancellables)
    }

    func bindingViewModel() {

        viewModel.emailValidation.sink { _ in
        } receiveValue: { [unowned self] message in
            self.emailField.descriptionLabel.text = message

        }.store(in: &cancellables)

        viewModel.nextButtonValidation.sink { _ in
        } receiveValue: { [unowned self] nextEnable  in
            self.changeNextButton(nextEnable)
        }.store(in: &cancellables)

        viewModel.goToNextPage.sink { [unowned self] in
            self.moveToPage()
        }.store(in: &cancellables)

    }

    private func changeNextButton( _ activation: Bool) {

        nextButton.backgroundColor = activation ? AppColor.mainColor.color : AppColor.gray183.color
        nextButton.isEnabled =  activation ? true : false

    }

    @objc func moveToPage() {
        if let pageController = parent as? SignupFlowViewController {
            pageController.temporaryUserInfo.email = emailField.textField.text
            pageController.pushNext()
        }
    }

    @objc func moveToPrevious() {
        if let pageController = parent as? SignupFlowViewController {
            pageController.pushPrevious()
        }
    }

}
