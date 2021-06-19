//
//  MyFavoriteViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/06/19.
//

import UIKit

class MyFavoriteViewController: UIViewController, ViewType {

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .blue
        table.register(MyFavoriteCompanyCell.self, forCellReuseIdentifier: MyFavoriteCompanyCell.reuseIdentifier)
        table.estimatedRowHeight = 40
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.dataSource = self
        return table
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupUI()
        self.setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraint() {
        tableView.fittingView(view)
    }

}

extension MyFavoriteViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoriteCompanyCell.reuseIdentifier) as? MyFavoriteCompanyCell else {
        return UITableViewCell()
        }
        cell.tableView.invalidateIntrinsicContentSize()
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
