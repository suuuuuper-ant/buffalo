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

    lazy var previousButton: UIButton = {
        let previous = UIButton()
        previous.setImage( UIImage(named: "icon_navigation_back"), for: .normal)
        return previous
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeDetailHeaderView.self, forCellReuseIdentifier: HomeDetailHeaderView.reuseIdentifier)
        tableView.register(HomeDetailLineChartCell.self, forCellReuseIdentifier: HomeDetailLineChartCell.reuseIdentifier)
        tableView.register(HomeDetailNewsListCell.self, forCellReuseIdentifier: HomeDetailNewsListCell.reuseIdentifier)
        tableView.register(HomeDetailBarChartCell.self, forCellReuseIdentifier: HomeDetailBarChartCell.reuseIdentifier)
        tableView.register(HomeDetailRelativeCell.self, forCellReuseIdentifier: HomeDetailRelativeCell.reuseIdentifier)

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
        setupConstraint()
        bindngUI()
        bindViewModel()
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
        tableView.backgroundColor = AppColor.homeBackground.color
        view.addSubview(tableView)
    }

    func setupConstraint() {
        tableView.fittingView(self.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = AppColor.homeBackground.color
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let cancelBarButton = UIBarButtonItem(customView: previousButton)
        self.navigationItem.leftBarButtonItems = [cancelBarButton]
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColor.homeBackground.color
        ]

        self.title = "프레스티지바이오로직스바이오"
        self.navigationController?.navigationBar.layoutIfNeeded()
    }

    func bindngUI() {

        previousButton.tapPublisher.sink { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)

    }
}

extension HomeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5

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
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailBarChartCell.reuseIdentifier) as? HomeDetailBarChartCell else { return UITableViewCell() }
            cell.configure(viewModel: viewModel)
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailRelativeCell.reuseIdentifier) as? HomeDetailRelativeCell else { return UITableViewCell() }

            let field = RelativeCompany(relativeFields: ["같은분야"], relativeKeyword: [], companyImage: "", company: "프레스티지바이오로직스바이오")
            let keyword = RelativeCompany(relativeFields: [], relativeKeyword: ["비슷한 시총 순위", "경기소비재"], companyImage: "", company: "닥터드레")
            cell.configure(field, keyword: keyword)
            return cell
        }

    }

}

extension HomeDetailViewController: UITableViewDelegate {

}

extension HomeDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 100 {
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColor.darkgray52.color
        ]

        } else {
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: AppColor.homeBackground.color
            ]
        }
    }
}
