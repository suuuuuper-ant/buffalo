//
//  HomeDetailViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/04.
//

import UIKit
import Combine

class HomeDetailViewModel: ObservableObject {
    var companyInfo: HomeCompanyInfo
    lazy var homeDetailReopository: HomeDetailRepository = DefaultHomeDetailRepository(homeDetailDataSource: DefaultHomeDetailDataSource(), homeDetailLineChartSource: DefaultHomeDetailLineChartDataSource(), company: companyInfo)

    let isReadMoreButtonTouched = PassthroughSubject<Bool, Error>()
    let goToRepoert = PassthroughSubject<String, Error>()
    @Published var data: HomeDetail?
    var subscriptions: Set<AnyCancellable> = []
    private var cancellables: Set<AnyCancellable> = []

    init(companyInfo: HomeCompanyInfo) {
        self.companyInfo = companyInfo

    }

    func reeadMoreButtonTouched(_ indexPath: IndexPath?) {
       // guard let indexPath = indexPath else { return }
        isReadMoreButtonTouched.send(true)

    }

    func fetch() {
        homeDetailReopository.getDetailPage()?.sink(receiveCompletion: { _ in

        }, receiveValue: { homeDetail in
            var home = homeDetail
            home.result.stacks.reverse()
            self.data =  home.result
        }).store(in: &subscriptions)

    }
}

protocol ViewType {
    func setupUI()
    func setupConstraint()
}

class HomeDetailViewController: UIViewController, ViewType {
    lazy var viewModel: HomeDetailViewModel = HomeDetailViewModel(companyInfo: self.homeSection.company)
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

    var homeSection: HomeUpdatedCompany

    func registerCell() {

    }

     init(companyInfo: HomeUpdatedCompany) {
        self.homeSection = companyInfo
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupConstraint()
        bindngUI()
        bindViewModel()

    }

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//
//    }

    func bindViewModel() {

        viewModel.isReadMoreButtonTouched.sink { _ in

        } receiveValue: { _ in
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(item: 3, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }.store(in: &cancellables)

        viewModel.goToRepoert.sink { _ in

        } receiveValue: { [ unowned self ]url in
            self.gotoReport(url: url)
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

        viewModel.fetch()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = AppColor.homeBackground.color
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        let cancelBarButton = UIBarButtonItem(customView: previousButton)
        self.navigationItem.leftBarButtonItems = [cancelBarButton]
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColor.homeBackground.color
        ]

        self.navigationController?.navigationBar.layoutIfNeeded()
    }

    func bindngUI() {

        previousButton.tapPublisher.sink { [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)

        viewModel
            .$data
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] data in
                self.title = viewModel.data?.company.shortName
                self.tableView.reloadData()
            }.store(in: &cancellables)

    }

    func gotoReport(url: String) {

        let reportVIew = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController
        reportVIew.newsURL = url
        reportVIew.modalPresentationStyle = .formSheet
        self.present(reportVIew, animated: true, completion: nil)
    }
}

extension HomeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.data == nil {
            return 0
        }
        return 5

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailHeaderView.reuseIdentifier) as? HomeDetailHeaderView else { return UITableViewCell() }
//            if let companyInfo = viewModel.data {
//                cell.c
//            }
            if let data =  viewModel.data {
                cell.configure(company: data.company, consensusList: data.consensusList)
            }

            return cell
        } else if indexPath.row == 1 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailLineChartCell.reuseIdentifier) as? HomeDetailLineChartCell else { return UITableViewCell() }
            let type = viewModel.data?.consensusList.first?.opinion
            let stock = StockType.init(rawValue: type?.rawValue ?? "")
            if let data = self.viewModel.data {
                cell.configure(stockType: stock ?? .none, data, parentViewMdoel: self.viewModel)
            }

            return cell

        } else  if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailNewsListCell.reuseIdentifier) as? HomeDetailNewsListCell else { return UITableViewCell() }
            if let data = viewModel.data {
                cell.configure(news: data.newsList)
            }

            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailBarChartCell.reuseIdentifier) as? HomeDetailBarChartCell else { return UITableViewCell() }
            cell.configure(viewModel: viewModel)
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailRelativeCell.reuseIdentifier) as? HomeDetailRelativeCell else { return UITableViewCell() }

            let field = RelativeCompany(relativeFields: ["같은분야"], relativeKeyword: [], companyImage: "", company: "SK하이닉스")
            let keyword = RelativeCompany(relativeFields: [], relativeKeyword: ["비슷한 시총 순위", "경기소비재"], companyImage: "", company: "LG화학")
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
