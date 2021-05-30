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
        tableView.register(InterestedCompanyCell.self, forCellReuseIdentifier: InterestedCompanyCell.reuseIdentifier)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedSectionHeaderHeight = 1500

        return tableView
    }()
    var tableHeaderView: UITableViewHeaderFooterView?

    var statusBarHeightConstant: NSLayoutConstraint?

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

                self?.header.configure(nickname: "가니", greeting: "오늘도 함께 디긴해요!", parentViewModel: self?.viewModel)
            self?.tableView.reloadData()
                self?.tableView.updateHeaderViewHeight()

        }.store(in: &cancellables)

        viewModel.moveToDetailPage
            .receive(on: DispatchQueue.main)
            .sink { _ in

            } receiveValue: { index in
                self.moveToDetail(index)
            }.store(in: &cancellables)

        viewModel.moveToRandomPick.sink { _ in

        } receiveValue: { [unowned self] _ in
            self.moveToRandomPick()
        }.store(in: &cancellables)

    }

    private func setupUI() {
        view.backgroundColor = .white
        tableView.backgroundColor = UIColor.init(named: "home_background")
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let statusBar = UIView()
        view.addSubview(tableView)
        view.addSubview(statusBar)

        statusBar.backgroundColor = UIColor.init(named: "home_background")
        statusBar.translatesAutoresizingMaskIntoConstraints = false
        statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statusBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        statusBarHeightConstant = statusBar.heightAnchor.constraint(equalToConstant: height)
        statusBarHeightConstant?.isActive = true

        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: statusBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITableView.appearance().separatorStyle = .none
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.statusBarHeightConstant?.constant = self.view.safeAreaInsets.top
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }

    func moveToDetail(_ indexPath: IndexPath) {
        let detail = HomeDetailViewController()
        guard let company = viewModel.data.data?.sections[indexPath.section].contents[indexPath.row] as? Company else { return }
        detail.homeSection = company

        self.navigationController?.pushViewController(detail, animated: true)
    }

    func moveToRandomPick() {

        self.navigationController?.pushViewController(RandomPickViewController(), animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.data?.sections.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard  let section = viewModel.data.data?.sections[section] else { return 0 }

        if section.groupId == "updatedCompany" {
            return 1
        } else if section.groupId == "intetestedCompany" {
            return section.contents.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section =  viewModel.data.data?.sections[indexPath.section] else { return UITableViewCell()}
        if section.groupId == "updatedCompany" {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeHorizontalGridCell.reuseIdentifier) as? HomeHorizontalGridCell
            let model = viewModel.data.data?.sections[indexPath.section].contents as? [Company] ?? []
            cell?.configure(with: model, parentViewModel: viewModel)
            return cell ?? UITableViewCell()
        } else if section.groupId == "intetestedCompany" {
            let cell = tableView.dequeueReusableCell(withIdentifier: InterestedCompanyCell.reuseIdentifier) as? InterestedCompanyCell
            if let model = viewModel.data.data?.sections[indexPath.section].contents[indexPath.row] as? InterestedCompany {
                cell?.configure(model: model)
                return cell ?? UITableViewCell()
            }

        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section =  viewModel.data.data?.sections[section] else { return nil }
        if section.groupId == "updatedCompany" {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeTitleHeaderView.reuseIdentifier) as? HomeTitleHeaderView
            header?.sectionLabel.text = "New Update"

            return header
        }
       return nil
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude

    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }

}

class HomeTitleHeaderView: UITableViewHeaderFooterView {

    let sectionLabel: UILabel = {
        let section = UILabel()
        section.font = UIFont.englishFont(ofSize: 16)
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
