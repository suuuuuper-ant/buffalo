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
    @Published var personalChecking = CurrentValueSubject<Bool, Never>(false)
    @Published  var serviceChecking = CurrentValueSubject<Bool, Never>(false)
    let updatChecking = PassthroughSubject<(String, Bool), Never>()

    var updatePersonal = PassthroughSubject<Bool, Never>()
    var updateService = PassthroughSubject<Bool, Never>()

    init() {

        self.personalChecking.sink { isChecked in
            self.updatePersonal.send(isChecked)
        }.store(in: &cancellables)

        self.serviceChecking.sink { isChecked in
            self.updateService.send(isChecked)
        }.store(in: &cancellables)

        self.updatChecking.sink { (path, isChecked) in
            self.updatePath(keypath: path, isChecked)
        }.store(in: &cancellables)
    }

    func updatePath( keypath: String, _ isChecked: Bool) {
        if keypath == "personal" {
            self.personalChecking.send(isChecked)
        } else {
            self.serviceChecking.send(isChecked)
        }
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

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

            self.viewModel.personalChecking.send(updatedChecking)
        }.store(in: &cancellables)

        personalInfoView.detailButton.tapPublisher.sink { [unowned self] _ in
            self.goToPersonalInfoCondition()
        }.store(in: &cancellables)

        serviceInfoView.checkImageView.tapPublisher.sink { [unowned self] _ in
            let updatedChecking = !serviceInfoView.isChecked
            self.serviceInfoView.isChecked = updatedChecking
            self.viewModel.serviceChecking.send(updatedChecking)
        }.store(in: &cancellables)

        serviceInfoView.detailButton.tapPublisher.sink { [unowned self] _ in
            self.goToServiceInfoCondition()
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

        viewModel.personalChecking.sink { isChecked in
            self.personalInfoView.isChecked = isChecked
        }.store(in: &cancellables)

        viewModel.serviceChecking.sink { isChecked in
            self.serviceInfoView.isChecked = isChecked
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

    func goToPersonalInfoCondition() {

        let model = TermAndConditionModel(navigationTitle: "이용약관 동의", mainTitle: "개인정보 수집이용", checkTitle: "개인정보 수집이용 동의(필수)", content: getTermAndConditionContentString(), keyPath: "personal")
        let viewModel = TermAndConditionDetailViewModel(termAndCondition: model)
        viewModel.parentViewModel = self.viewModel
        let serviceInfoCondition = TermAndConditionDetailViewController(viewModel: viewModel)

        self.navigationController?.pushViewController(serviceInfoCondition, animated: true)
    }

    func goToServiceInfoCondition() {
        let model = TermAndConditionModel(navigationTitle: "이용약관 동의", mainTitle: "서비스 이용약관", checkTitle: "서비스 이용약관 동의(필수)", content: getTermAndConditionContentString(), keyPath: "service")
        let viewModel = TermAndConditionDetailViewModel(termAndCondition: model)
        viewModel.parentViewModel = self.viewModel
        let serviceInfoCondition = TermAndConditionDetailViewController(viewModel: viewModel)

        self.navigationController?.pushViewController(serviceInfoCondition, animated: true)
    }

    deinit {
        print("TermsAndConditionsViewController")
    }

    func getTermAndConditionContentString() -> String {

    return  """
        *제1조(목적)
        본 약관은 디긴 투자정보서비스 (이하 회사라고 합니다)가 제공하는 인터넷 기반의 모바일 어플리케이션 디긴(DIGIN) 서비스의 이용과 관련하여 회원과 회사 간에 필요한 사항을 규정하기 위함을 목적으로 합니다.



        *제2조(용어의 정의)


        ① 본 약관에서 사용하는 용어의 정의는 다음과 같습니다.

        1. “서비스”라 함은 회사가 개발하여 인터넷을 통하여 서비스하고 있는 서비스 및 기타 서비스 일체를 의미합니다.

        2. “회원”이라 함은 회사가 운영하는 사이트에 접속하여 본 약관에 동의하고 회원 가입을 한 자로서, 회사와 서비스 이용 계약을 체결하고 서비스 이용 아이디와 비밀번호를 부여 받아 서비스를 이용하는 고객을 말합니다.

        3. "아이디"라 함은 회원의 식별과 회원의 서비스 이용을 위하여 "회원"이 가입 시 사용한 이메일 주소를 말한다.

        ② 본 약관에서 사용하는 용어의 정의에 대하여 본 조 제1항에서 정하는 것을 제외하고는 관계법령 및 서비스별 정책에서 정하는 바에 의하며, 관계법령과 서비스별 정책에서 정하지 아니한 것은 일반적인 상관례에 의합니다.



        *제3조(약관의 게시와 개정)


        ① 회사는 본 약관의 내용을 회원이 쉽게 확인할 수 있도록 서비스 내 또는 연결화면을 통하여 게시합니다.
        ② 회원 가입 시 본 약관에 동의한 회원은 동의한 때로부터 본 약관의 적용을 받게 되며, 약관이 개정된 경우에는 개정된 약관의 효력이 발생하는 시점부터 개정된 약관의 적용을 받습니다.
        ③ 회사는 필요한 경우 관련 법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.
        """
    }

    func getServiceInfoCondition() -> String {

       return """
        * 디긴(DIGIN) 개인정보처리방침


        디긴 투자정보서비스 (이하 ‘회사’)는 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「개인정보 보호법」 등 관련 법령상의 개인정보보호 규정을 준수하며, 관련 법령에 의거한 개인정보처리방침을 정하여 고객의 권익 보호에 최선을 다하고 있습니다.회사는 본 개인정보처리방침(이하 ‘본 방침’)을 통하여 고객이 제공하는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며, 개인정보보호를 위해 어떠한 조치가 취해지고 있는지를 알려드립니다.



        *제1조(개인정보의 처리목적)


        회사는 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용되지 않습니다.


        1. 회원 가입 및 관리


        회원제 서비스 이용에 따른 본인확인, 가입의사 확인, 연령에 따른 서비스 제한, 개인식별, 불량회원의 부정 이용방지, 분쟁조정을 위한 기록 보존, 불만처리 등 민원처리, 고지사항 전달


        2. 서비스의 제공에 관한 계약 이행


        서비스 및 컨텐츠 제공, 특정 맞춤 서비스의 제공, 운용보고서의 발송 등과 관련된 목적


        3. 신규 서비스의 개발, 마케팅 및 광고


        통계 추적 및 분석, 신규 서비스 개발 및 맞춤 서비스의 제공, 통계학적 특성에 따른 서비스 제공, 이벤트 및 광고성 정보의 제공 및 참여기회 제공, 접속빈도 파악, 회원의 서비스 이용에 대한 통계.



        *제2조(개인정보의 수집항목 및 수집방법)


        회사는 회원가입, 원활한 고객상담, 각종 서비스의 제공을 위해 처리하는 개인정보의 항목 및 수집 방법은 다음과 같습니다.
        """
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
