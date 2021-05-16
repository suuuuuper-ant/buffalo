//
//  SignupInterestingViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/15.
//

import UIKit
import Combine

class SignupInterestingViewController: UIViewController, ViewType {
    var cancellables: Set<AnyCancellable> = []
    struct UI {
        static let selectNumber = 3
    }

    var selectedIndexPaths: Set<IndexPath> = [] {
        didSet {
            updateDiginButton(nextStep: nextStep)
        }
    }

    var nextStep: Bool {
        return selectedIndexPaths.count >= UI.selectNumber
    }

    var data: [Interesting] = [
        Interesting(image: "login_top", interesting: "삼성전자"),
        Interesting(image: "login_top", interesting: "삼성전자 두 줄인 경우"),
        Interesting(image: "login_top", interesting: "여섯글자에요"),
        Interesting(image: "login_top", interesting: "삼성전자"),
        Interesting(image: "login_top", interesting: "삼성전자"),
        Interesting(image: "login_top", interesting: "삼성전자"),
        Interesting(image: "login_top", interesting: "삼성전자"),
        Interesting(image: "login_top", interesting: "삼성전자"),
        Interesting(image: "login_top", interesting: "삼성전자"),
        Interesting(image: "login_top", interesting: "삼성전자")

    ]

    var guide: String = "" {
        didSet {
            guideLabel.text = guide
        }
    }

    lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(SingupInterestingCell.self, forCellWithReuseIdentifier: SingupInterestingCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        layout.minimumInteritemSpacing = 17
        layout.minimumLineSpacing = 9
        let collectionViewWidth = (view.bounds.width - 40 - 34)
        layout.itemSize = CGSize(width: collectionViewWidth / 3, height: 142)
        return layout
    }()

    lazy var buttomView: UIView = {
        let buttomView = UIView()
        let line = UIView()
        line.backgroundColor = AppColor.homeBackground.color

        buttomView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        buttomView.addSubview(diginStartButton)
        diginStartButton.translatesAutoresizingMaskIntoConstraints = false
        // buttom View line
        line.leadingAnchor.constraint(equalTo: buttomView.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: buttomView.trailingAnchor).isActive = true
        line.topAnchor.constraint(equalTo: buttomView.topAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //buttomView button
        diginStartButton.centerXAnchor.constraint(equalTo: buttomView.centerXAnchor).isActive = true
        diginStartButton.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 16).isActive = true
        diginStartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        diginStartButton.leadingAnchor.constraint(equalTo: buttomView.leadingAnchor, constant: 20).isActive = true
        diginStartButton.trailingAnchor.constraint(equalTo: buttomView.trailingAnchor, constant: -20).isActive = true

        return buttomView
    }()

    lazy var diginStartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("디긴 시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = AppColor.dividerColor.color
        button.makeRounded(cornerRadius: 25)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
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
        guide = "가장 관심이 가는 기업을\n3개 선택해 주세요"
        bindingUI()
    }

    func setupUI() {

        [guideLabel, collectionView, buttomView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

    }

    func bindingUI() {

        diginStartButton.tapPublisher.sink { [unowned self] _ in
            self.signupWithUserInfo()

        }.store(in: &cancellables)
    }

    func setupConstraint() {
        guideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        collectionView.topAnchor.constraint(equalTo: guideLabel.bottomAnchor, constant: 58).isActive = true

        buttomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttomView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        buttomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        buttomView.heightAnchor.constraint(equalToConstant: 113).isActive = true

    }

    func updateDiginButton( nextStep: Bool) {

        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            if nextStep {
                self?.diginStartButton.backgroundColor = AppColor.mainColor.color
                self?.diginStartButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                self?.diginStartButton.isEnabled = true
            } else {
                self?.diginStartButton.setTitleColor(.white, for: .normal)
                self?.diginStartButton.backgroundColor = AppColor.dividerColor.color
                self?.diginStartButton.isEnabled = false
            }
        })
    }

    func signupWithUserInfo() {

        let interestings = selectedIndexPaths.map { indexPath in
            return data[indexPath.row].interesting
        }

        if let pageViewController = parent as? SignupFlowViewController {

            pageViewController.temporaryUserInfo.interestings = interestings
            print(pageViewController.temporaryUserInfo)
        }

        // api콜
    }

}

extension SignupInterestingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingupInterestingCell.reuseIdentifier, for: indexPath) as? SingupInterestingCell
        let model = data[indexPath.row]
        let isSelected = selectedIndexPaths.contains(indexPath)

        cell?.configure(model, isSelected: isSelected)
        return cell ?? UICollectionViewCell()
    }
}

extension SignupInterestingViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if nextStep || selectedIndexPaths.contains(indexPath) {
            selectedIndexPaths.remove(indexPath)
            collectionView.reloadItems(at: [indexPath])
            return

        } else {
            selectedIndexPaths.insert(indexPath)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
