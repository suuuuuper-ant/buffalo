//
//  TermsAndConditionsViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/18.
//

import UIKit
import Combine

class SheetView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.topRight, .topLeft],
                                cornerRadii: CGSize(width: 30, height: 30))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

class TermsAndConditionsViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = []
    let personalChecking = PassthroughSubject<Bool, Never>()
    let serviceChecking = PassthroughSubject<Bool, Never>()

    init() {

    }
}

class TermsAndConditionsViewController: UIViewController, ViewType {
    var cancellables: Set<AnyCancellable> = []
    var sheetTopContraints: NSLayoutConstraint?
    var viewModel = TermsAndConditionsViewModel()
    var parentVC: LoginViewController?
    lazy var termsAndConditionsLabel: UILabel = {

        let conditions = UILabel()
        conditions.text = "디긴 이용약관 동의"
        conditions.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return conditions
    }()

    var sheetHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.4
    }

    lazy var sheetView: SheetView = {

        let sheet = SheetView()
        sheet.backgroundColor = .white
        return sheet
    }()

    lazy var cancelButton: UIButton = {

        let cancel = UIButton()
        cancel.setImage(UIImage(named: "icon_cancel"), for: .normal)
        return cancel
    }()

    lazy var personalInfoView: TermAndConditionCheckView = {

        let personalInfo = TermAndConditionCheckView()
        personalInfo.conditionLabel.text = "개인정보 수집이용 동의 (필수)"
        return personalInfo
    }()

    lazy var serviceInfoView: TermAndConditionCheckView = {

        let serviceInfo = TermAndConditionCheckView()
        serviceInfo.conditionLabel.text = "서비스 이용약관 동의 (필수)"
        return serviceInfo
    }()

    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.text = "모든 약관에 동의해 주세요."
        description.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        description.textColor = AppColor.stockRed.color
        description.isHidden = true
        return description
    }()

    lazy var signupButton: UIButton = {
        let signup = UIButton()
        signup.setTitle("가입하기", for: .normal)
        signup.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        signup.titleLabel?.textColor = UIColor.white
        signup.layer.cornerRadius = 50 / 2
        signup.layer.masksToBounds = true
        signup.backgroundColor = AppColor.lightgray225.color
        return signup
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupConstraint()
        bindingUI()
        bindingViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sheetTopContraints?.constant = -sheetHeight

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func bindingUI() {

        cancelButton.tapPublisher.sink { [unowned self] _ in
            self.view.backgroundColor = .clear
            self.sheetTopContraints?.constant = 0

            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn]) {
                self.view.layoutIfNeeded()
                self.view.setNeedsDisplay()
            } completion: { [weak self] _ in
                self?.dismiss(animated: false)
            }
        }.store(in: &cancellables)

        personalInfoView.checkImageView.tapPublisher.sink { [unowned self] _ in
            let updatedChecking = !personalInfoView.isChecked
            self.personalInfoView.isChecked = updatedChecking
            self.viewModel.personalChecking.send(updatedChecking)
        }.store(in: &cancellables)

        serviceInfoView.checkImageView.tapPublisher.sink { [unowned self] _ in
            let updatedChecking = !serviceInfoView.isChecked
            self.serviceInfoView.isChecked = updatedChecking
            self.viewModel.serviceChecking.send(updatedChecking)
        }.store(in: &cancellables)

        signupButton.tapPublisher.sink { [unowned self] in

            self.view.backgroundColor = .clear
            self.sheetTopContraints?.constant = 0

            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn]) {
                self.view.layoutIfNeeded()
                self.view.setNeedsDisplay()
            } completion: { _ in
                self.dismiss(animated: false, completion: {
                    self.parentVC?.goToSignupFlow()
                })
            }

        }.store(in: &cancellables)

    }

    func bindingViewModel() {

        viewModel.personalChecking.combineLatest(viewModel.serviceChecking).sink { [unowned self] personalCheckong, serviceChecking in
            self.updateSignupButton(isActive: personalCheckong && serviceChecking)
            self.updateDescriptionLabel(isActive: personalCheckong && serviceChecking)
        }.store(in: &cancellables)
    }

    func setupUI() {
        view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false

        [termsAndConditionsLabel, cancelButton, personalInfoView, serviceInfoView, descriptionLabel, signupButton].forEach {

            sheetView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false

        }
    }

    func setupConstraint() {

        sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sheetView.heightAnchor.constraint(equalToConstant: sheetHeight).isActive = true

        sheetTopContraints = sheetView.topAnchor.constraint(equalTo: view.bottomAnchor)
        sheetTopContraints?.isActive = true

        termsAndConditionsLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20).isActive = true
        termsAndConditionsLabel.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 40).isActive = true
        termsAndConditionsLabel.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -20).isActive = true
        // cancel

        cancelButton.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: termsAndConditionsLabel.centerYAnchor).isActive = true

        // personal

        personalInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        personalInfoView.topAnchor.constraint(equalTo: termsAndConditionsLabel.bottomAnchor, constant: 40).isActive = true
        personalInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        personalInfoView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // service
        serviceInfoView.leadingAnchor.constraint(equalTo: personalInfoView.leadingAnchor).isActive = true
        serviceInfoView.topAnchor.constraint(equalTo: personalInfoView.bottomAnchor, constant: 17).isActive = true
        serviceInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        serviceInfoView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // description

        descriptionLabel.leadingAnchor.constraint(equalTo: serviceInfoView.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: serviceInfoView.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        // signup
        signupButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor).isActive = true
        signupButton.topAnchor.constraint(equalTo: serviceInfoView.bottomAnchor, constant: 65).isActive = true
        signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

    func updateSignupButton(isActive: Bool) {
        signupButton.isEnabled = isActive
        signupButton.backgroundColor =  isActive ? AppColor.mainColor.color : AppColor.lightgray225.color
    }

    func updateDescriptionLabel(isActive: Bool) {
        descriptionLabel.isHidden =  isActive ? true : false
    }

    deinit {
        print("TermsAndConditionsViewController")
    }

}

class TermAndConditionCheckView: UIView, ViewType {

    lazy var checkImageView: UIButton = {

        let check = UIButton()
        check.setImage(UIImage(named: "icon_check_empty"), for: .normal)
        return check
    }()

    lazy var conditionLabel: UILabel = {

        let condition = UILabel()
        condition.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        condition.text = ""
        return condition
    }()

    lazy var detailButton: UIButton = {

        let detail = UIButton()
        detail.setImage(UIImage(named: "icon_arrow_right"), for: .normal)
        return detail
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("fatal error")
    }

    func setupUI() {
        [checkImageView, conditionLabel, detailButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

     var isChecked: Bool = false {
        didSet {
            updateCheckImage(isChecked)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func setupConstraint() {

        //checkImage
        checkImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        checkImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        //label
        conditionLabel.leadingAnchor.constraint(equalTo: checkImageView.trailingAnchor, constant: 10).isActive = true
        conditionLabel.centerYAnchor.constraint(equalTo: checkImageView.centerYAnchor).isActive = true

        //arrow button

        detailButton.leadingAnchor.constraint(equalTo: conditionLabel.trailingAnchor, constant: 3).isActive = true
        detailButton.centerYAnchor.constraint(equalTo: conditionLabel.centerYAnchor).isActive = true
        detailButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        detailButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func updateCheckImage(_ isCheck: Bool) {
        let imageString =   isCheck ? "icon_ check_completed" :  "icon_check_empty"
        checkImageView.setImage(UIImage(named: imageString), for: .normal)

    }

}
