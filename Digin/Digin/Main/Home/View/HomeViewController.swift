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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionHeaderHeight = 354
        return tableView
    }()

    var data  = [
        ["제약", "바이오", "제넥신"], ["국방", "화학", "수출"],
        ["배", "조선", "미국경제악화"], ["달러약세"],
        ["석유", "러시아"], ["배급사", "마블", "넷플릭스"]
    ]

    var viewModel: HomeViewModel = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        bindViewModel()
        viewModel.fetch()

    }

    func bindViewModel() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }

    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
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
