//
//  ServiceInfoConditionViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/20.
//

import UIKit
import Combine

struct TermAndConditionModel {
    var navigationTitle: String = ""
    var mainTitle: String = ""
    var checkTitle: String = ""
    var content: String = ""
    var keyPath: String = ""
}

class TermAndConditionDetailViewModel: ObservableObject {
    var parentViewModel: TermsAndConditionsViewModel?
    var termAndCondition = TermAndConditionModel()
    let updateChecking = PassthroughSubject<Void, Never>()
    var cancellables: Set<AnyCancellable> = []

   @Published var isCheck = false

    init(termAndCondition: TermAndConditionModel) {
        self.termAndCondition = termAndCondition

        updateChecking.sink { [unowned self]  _ in
            self.parentViewModel?.updatChecking.send((termAndCondition.keyPath, isCheck))
        }.store(in: &cancellables)

    }
}

class TermAndConditionDetailViewController: UIViewController, ViewType {
    var cancellables: Set<AnyCancellable> = []
    var viewModel: TermAndConditionDetailViewModel

    init(viewModel: TermAndConditionDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var previousButton: UIButton = {

        let previous = UIButton(type: .custom)
        previous.setImage( UIImage(named: "icon_navigation_back"), for: .normal)

        return previous
    }()

    lazy var titleLabel: UILabel = {

       let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .black
        return title
    }()

    lazy var detailTitleLabel: UILabel = {

       let detail = UILabel()
        detail.text = "개인정보 수집이용"
        detail.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        detail.textColor = .black
        return detail
    }()

    lazy var detailTextView: UITextView = {

       let detailText = UITextView()
        detailText.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        detailText.textColor = .black
        return detailText
    }()

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

    override var title: String? {
        didSet {
            titleLabel.text = title
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationItem.titleView = nil

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let cancelBarButton = UIBarButtonItem(customView: previousButton)
        let titleLabelBarButton = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItems = [cancelBarButton, titleLabelBarButton]

        //네비바 커스텀
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupUI() {

        previousButton.translatesAutoresizingMaskIntoConstraints = false
        [detailTitleLabel, detailTextView, checkImageView, conditionLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        titleLabel.text = viewModel.termAndCondition.navigationTitle
        detailTitleLabel.text = viewModel.termAndCondition.mainTitle
        conditionLabel.text = viewModel.termAndCondition.checkTitle
        detailTextView.text = viewModel.termAndCondition.content
        bindingUI()

    }

    func setupConstraint() {
        previousButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant: 25).isActive = true

        detailTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        detailTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true

        detailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        detailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        detailTextView.topAnchor.constraint(equalTo: detailTitleLabel.bottomAnchor, constant: 20).isActive = true
        detailTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true

        checkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33).isActive = true
        checkImageView.topAnchor.constraint(equalTo: detailTextView.bottomAnchor, constant: 20).isActive = true
        checkImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
        checkImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true

        conditionLabel.leadingAnchor.constraint(equalTo: checkImageView.trailingAnchor, constant: 13).isActive = true
        conditionLabel.centerYAnchor.constraint(equalTo: checkImageView.centerYAnchor).isActive = true

    }

    private func bindingUI() {

        checkImageView.tapPublisher.sink { [unowned self] _ in
            let updatedChecking = self.viewModel.isCheck
            self.viewModel.isCheck = !updatedChecking
            self.updateCheckImage(!updatedChecking)
        }.store(in: &cancellables)

        previousButton.tapPublisher.sink { [unowned self] _ in
            self.viewModel.updateChecking.send()
            self.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
    }

    func updateCheckImage(_ isCheck: Bool) {
        let imageString =   isCheck ? "icon_ check_completed" :  "icon_check_empty"
        checkImageView.setImage(UIImage(named: imageString), for: .normal)

    }

}
