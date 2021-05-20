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
        let model = TermAndConditionModel(navigationTitle: "이용약관 동의", mainTitle: "개인정보 수집이용", checkTitle: "개인정보 수집이용 동의(필수)", content: "보는 청춘의 얼마나 보라. 가지에 현저하게 생생하며, 하는 길을 원대하고, 뜨고, 사막이다. 이상의 이상의 길을 이상의 되려니와, 사는가 바이며, 동산에는 사막이다. 물방아 것은 않는 장식하는 이상의 힘있다. 있는 하여도 실현에 것은 구하지 그러므로 안고, 사랑의 이상 철환하였는가? 그들에게 소담스러운 앞이 반짝이는 아름답고 장식하는 가치를 인간이 사막이다. 군영과 피는 인생에 끝에 생명을 무엇을 싶이 위하여서, 곳이 칼이다. 몸이 얼음에 보이는 위하여 이상을 새가 피가 그리하였는가? 구할 때까지 용기가 역사를 힘차게 인도하겠다는 봄바람이다.있으며, 귀는 이상의 못할 피고 황금시대를 사막이다. 없으면 낙원을 놀이 피다. 발휘하기 우리는 이것을 능히 예수는 따뜻한 바이며, 위하여서. 돋고, 품고 어디 살 위하여서, 듣는다. 트고, 새 것은 풀밭에 미묘한 사는가 이것이다. 바로 반짝이는 두손을 이것이다. 없으면, 뭇 것이다.보라, 피가 불어 철환하였는가? 가지에 귀는 속잎나고, 크고 그들을 주는 가슴이 오직 봄날의 힘있다. 낙원을 얼음과 평화스러운 이것이다.들어 창공에 그것은 있는 어디 아름다우냐? 창공에 가치를 원질이 봄바람이다. 곧 할지니, 얼마나 피부가 얼음과 청춘이 있을 것이다. 청춘 우리의 인간이 힘차게 꽃이 풀이 만천하의 때에, 있으랴? 품에 이상은 너의 그들에게 뛰노는 되려니와, 이것이다. 인생을 충분히 새 방황하였으며, 것이다. 위하여, 품으며, 평화스러운 오아이스도 불러 싹이 그들의 것이다. 꾸며 위하여서, 그들에게 소금이라 듣는다. 이것을 보는 꽃 뿐이다. 그러므로 듣기만 소금이라 열락의 얼마나 청춘을 위하여서, 가치를 약동하다. 동력은 석가는 설산에서 따뜻한 대한 있다.", keyPath: "personal")
        let viewModel = TermAndConditionDetailViewModel(termAndCondition: model)
        viewModel.parentViewModel = self.viewModel
        let serviceInfoCondition = TermAndConditionDetailViewController(viewModel: viewModel)
        serviceInfoCondition.title = "이용약관 동의"
        self.navigationController?.pushViewController(serviceInfoCondition, animated: true)
    }

    func goToServiceInfoCondition() {
        let model = TermAndConditionModel(navigationTitle: "이용약관 동의", mainTitle: "서비스 이용약관", checkTitle: "서비스 이용약관 동의(필수)", content: "보는 청춘의 얼마나 보라. 가지에 현저하게 생생하며, 하는 길을 원대하고, 뜨고, 사막이다. 이상의 이상의 길을 이상의 되려니와, 사는가 바이며, 동산에는 사막이다. 물방아 것은 않는 장식하는 이상의 힘있다. 있는 하여도 실현에 것은 구하지 그러므로 안고, 사랑의 이상 철환하였는가? 그들에게 소담스러운 앞이 반짝이는 아름답고 장식하는 가치를 인간이 사막이다. 군영과 피는 인생에 끝에 생명을 무엇을 싶이 위하여서, 곳이 칼이다. 몸이 얼음에 보이는 위하여 이상을 새가 피가 그리하였는가? 구할 때까지 용기가 역사를 힘차게 인도하겠다는 봄바람이다.있으며, 귀는 이상의 못할 피고 황금시대를 사막이다. 없으면 낙원을 놀이 피다. 발휘하기 우리는 이것을 능히 예수는 따뜻한 바이며, 위하여서. 돋고, 품고 어디 살 위하여서, 듣는다. 트고, 새 것은 풀밭에 미묘한 사는가 이것이다. 바로 반짝이는 두손을 이것이다. 없으면, 뭇 것이다.보라, 피가 불어 철환하였는가? 가지에 귀는 속잎나고, 크고 그들을 주는 가슴이 오직 봄날의 힘있다. 낙원을 얼음과 평화스러운 이것이다.들어 창공에 그것은 있는 어디 아름다우냐? 창공에 가치를 원질이 봄바람이다. 곧 할지니, 얼마나 피부가 얼음과 청춘이 있을 것이다. 청춘 우리의 인간이 힘차게 꽃이 풀이 만천하의 때에, 있으랴? 품에 이상은 너의 그들에게 뛰노는 되려니와, 이것이다. 인생을 충분히 새 방황하였으며, 것이다. 위하여, 품으며, 평화스러운 오아이스도 불러 싹이 그들의 것이다. 꾸며 위하여서, 그들에게 소금이라 듣는다. 이것을 보는 꽃 뿐이다. 그러므로 듣기만 소금이라 열락의 얼마나 청춘을 위하여서, 가치를 약동하다. 동력은 석가는 설산에서 따뜻한 대한 있다.", keyPath: "service")
        let viewModel = TermAndConditionDetailViewModel(termAndCondition: model)
        viewModel.parentViewModel = self.viewModel
        let serviceInfoCondition = TermAndConditionDetailViewController(viewModel: viewModel)
        serviceInfoCondition.title = "이용약관 동의"
        self.navigationController?.pushViewController(serviceInfoCondition, animated: true)
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
