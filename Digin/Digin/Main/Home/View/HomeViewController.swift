//
//  HomeViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//
import UIKit
import Combine

class HomeViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeHorizontalGridCell.self, forCellReuseIdentifier: HomeHorizontalGridCell.reuseIdentifier)
        tableView.register(HomeTitleHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeTitleHeaderView.reuseIdentifier)
        tableView.register(HomeGreetingHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeGreetingHeaderView.reuseIdentifier)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionHeaderHeight = 1500

        return tableView
    }()
    var tableHeaderView: UITableViewHeaderFooterView?
    var data  = [
        ["제약", "바이오", "제넥신"], ["국방", "화학", "수출"],
        ["배", "조선", "미국경제악화"], ["달러약세"],
        ["석유", "러시아"], ["배급사", "마블", "넷플릭스"]
    ]

    var viewModel: HomeViewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []
    lazy var header = HomeGreetingHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1000))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        bindViewModel()
        viewModel.fetch()
        tableView.tableHeaderView = header
    }

    func bindViewModel() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.header.greetingLabel.text  = "daskldsaldkjaskldsjadlksajdaklsdjiqdaskldsaldkjaskldsjadlksajdaklsdjiqdaskldsaldkjaskldsjadlksajdaklsdjiqdaskldsaldkjaskldsjadlksajdaklsdjiq"
            self?.tableView.reloadData()
                self?.tableView.updateHeaderViewHeight()

        }.store(in: &cancellables)
    }

    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = UIColor.init(named: "home_background")
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITableView.appearance().separatorStyle = .none
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeHorizontalGridCell.reuseIdentifier) as? HomeHorizontalGridCell
        cell?.configure(with: viewModel.data)
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTitleHeaderView.reuseIdentifier) as? HomeTitleHeaderView
        header?.sectionLabel.text = "New Update"

        return header
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let view: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 20))
        view.backgroundColor = .white

        return view
    }
}

class HomeTitleHeaderView: UITableViewHeaderFooterView {

    let sectionLabel: UILabel = {
        let section = UILabel()
        return section
    }()
    let backContentView = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(backContentView)
        backContentView.translatesAutoresizingMaskIntoConstraints = false
        backContentView.fittingView(contentView)
        backContentView.addSubview(sectionLabel)

        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 20).isActive = true
        sectionLabel.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -20).isActive = true
        sectionLabel.topAnchor.constraint(equalTo: backContentView.topAnchor, constant: 0).isActive = true
        sectionLabel.bottomAnchor.constraint(equalTo: backContentView.bottomAnchor, constant: -16).isActive = true

    }
}
