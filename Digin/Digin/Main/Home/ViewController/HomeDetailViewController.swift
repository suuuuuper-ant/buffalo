//
//  HomeDetailViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/04.
//

import UIKit
import Combine

class HomeDetailViewModel: ObservableObject {

    let isReadMoreButtonTouched = PassthroughSubject<Bool, Error>()
    private var cancellables: Set<AnyCancellable> = []

    func reeadMoreButtonTouched(_ indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        isReadMoreButtonTouched.send(true)

    }
}

protocol ViewType {
    func setupUI()
    func setupConstraint()
}

class HomeDetailViewController: UIViewController, ViewType {
    var viewModel: HomeDetailViewModel = HomeDetailViewModel()
    private var cancellables: Set<AnyCancellable> = []

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeDetailHeaderView.self, forCellReuseIdentifier: HomeDetailHeaderView.reuseIdentifier)
        tableView.register(HomeDetailLineChartCell.self, forCellReuseIdentifier: HomeDetailLineChartCell.reuseIdentifier)
        tableView.register(HomeDetailNewsListCell.self, forCellReuseIdentifier: HomeDetailNewsListCell.reuseIdentifier)
        tableView.register(HomeDetailBarChartCell.self, forCellReuseIdentifier: HomeDetailBarChartCell.reuseIdentifier)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionHeaderHeight = 1500

        return tableView
    }()

    var data  = [
        ["제약", "바이오", "제넥신"], ["국방", "화학", "수출"],
        ["배", "조선", "미국경제악화"], ["달러약세"],
        ["석유", "러시아"], ["배급사", "마블", "넷플릭스"]
    ]

    func registerCell() {

    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        bindViewModel()

        setupConstraint()
    }

    func bindViewModel() {
        viewModel.isReadMoreButtonTouched.sink { _ in

        } receiveValue: { _ in
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }.store(in: &cancellables)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI() {
        tableView.backgroundColor = UIColor.init(named: "home_background")
        view.addSubview(tableView)
    }

    func setupConstraint() {
        tableView.fittingView(self.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension HomeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailHeaderView.reuseIdentifier) as? HomeDetailHeaderView else { return UITableViewCell() }
            cell.configure(tags: data[indexPath.row])
            return cell
        } else if indexPath.row == 1 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailLineChartCell.reuseIdentifier) as? HomeDetailLineChartCell else { return UITableViewCell() }
            return cell

        } else  if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailNewsListCell.reuseIdentifier) as? HomeDetailNewsListCell else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailBarChartCell.reuseIdentifier) as? HomeDetailBarChartCell else { return UITableViewCell() }
            cell.configure(viewModel: viewModel)
            return cell

        }

    }

}

extension HomeDetailViewController: UITableViewDelegate {

}
