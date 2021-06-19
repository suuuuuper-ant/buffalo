//
//  MyFavoriteCompanyCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/06/19.
//

import UIKit

class MyFavoriteCompanyCell: UITableViewCell, ViewType {

    lazy var cornerBackGroundView: UIView = {
        let cornerBackGround = UIView()
        cornerBackGround.layer.cornerRadius = 20
        cornerBackGround.clipsToBounds = true
        cornerBackGround.backgroundColor = AppColor.lightgray249.color
        return cornerBackGround
    }()

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.backgroundColor = .red
        table.dataSource = self
        table.estimatedRowHeight = 40
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.register(MyFavoriteDetailCell.self, forCellReuseIdentifier: MyFavoriteDetailCell.reuseIdentifier)
        return table
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraint()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.reloadData()
    }

    func setupUI() {
        [cornerBackGroundView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        cornerBackGroundView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraint() {
        cornerBackGroundView.fittingView(contentView)

        // tableView
        tableView.leadingAnchor.constraint(equalTo: cornerBackGroundView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: cornerBackGroundView.trailingAnchor, constant: -20).isActive = true
        tableView.topAnchor.constraint(equalTo: cornerBackGroundView.topAnchor, constant: 5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: cornerBackGroundView.bottomAnchor, constant: -5).isActive = true

    }

}

extension MyFavoriteCompanyCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoriteDetailCell.reuseIdentifier) as? MyFavoriteDetailCell else {
        return UITableViewCell()
        }

        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
