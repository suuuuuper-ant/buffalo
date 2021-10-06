//
//  HomeGridConsensusView.swift
//  Digin
//
//  Created by jinho jeong on 2021/10/06.
//

import UIKit

final class HomeGridConsensusView: UIView {

    var iconImageView: UIImageView = {
        let icon = UIImageView()
        return icon
    }()

    var titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        return title
    }()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        table.register(HomeNewsCell.self, forCellReuseIdentifier: HomeNewsCell.reuseIdentifier)
        table.rowHeight = 30
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.lightgray239.color.withAlphaComponent(0.2)
        addSubiews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubiews() {
        [iconImageView, titleLabel, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }

    private func setupConstraints() {
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 17).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 23).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 23).isActive = true

        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 3).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor).isActive = true

        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    }

    func configure(_ model: [Consensus]) {
        setNeedsLayout()
        self.model = model
        titleLabel.text = model.first?.opinion.decription()
        titleLabel.textColor = model.first?.opinion.colorForType()
        iconImageView.image = model.first?.opinion.stockTypeIconImage()

    }

    var model: [Consensus] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
}

extension HomeGridConsensusView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeNewsCell = tableView.dequeueReusableCell(withIdentifier: HomeNewsCell.reuseIdentifier) as? HomeNewsCell
        let news = self.model[indexPath.section]
        homeNewsCell?.configure(consensus: news)
        homeNewsCell?.selectionStyle = .none
        return homeNewsCell ?? UITableViewCell()
    }

}
