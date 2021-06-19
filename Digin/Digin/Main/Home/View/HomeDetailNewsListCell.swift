//
//  HomeDetailNewsListCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/07.
//

import UIKit

class HomeDetailNewsListCell: UITableViewCell, ViewType {

    struct UI {
        static let contentLeading: CGFloat = 20
        static let contentTrailing: CGFloat = -20
        static let contentTop: CGFloat = 20
        static let contentBottom: CGFloat = -10
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(HomeDetailNewsCell.self, forCellReuseIdentifier: HomeDetailNewsCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var backContentView: UIView = {
        let content = UIView()
        content.makeRounded(cornerRadius: 15)
        content.backgroundColor = .white
        return content
    }()

    lazy var dividedLine: UIView = {

        let line = UIView()
        line.backgroundColor = UIColor.init(named: "divider_color")
        return line
    }()

    lazy var moreLabel: UILabel = {
        let moreLabel = UILabel()
        moreLabel.text = "뉴스 더보기"
        moreLabel.textColor = UIColor(named: "darkgray_82")
        moreLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return moreLabel
    }()

    lazy var moreButton: UIButton = {
        let more = UIButton()
        more.setImage(UIImage(named: "home_new_more"), for: .normal)
        return more
    }()

    var news: [News] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        contentView.backgroundColor = UIColor.init(named: "home_background")
        contentView.addSubview(backContentView)
        backContentView.translatesAutoresizingMaskIntoConstraints = false
        [tableView, dividedLine, moreLabel, moreButton].forEach {
            backContentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraint() {

        backContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UI.contentLeading).isActive = true
        backContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UI.contentTrailing).isActive = true
        backContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UI.contentTop).isActive = true
        backContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: UI.contentBottom).isActive = true
        backContentView.heightAnchor.constraint(equalToConstant: 354).isActive = true
        tableView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 16).isActive = true

        tableView.topAnchor.constraint(equalTo: backContentView.topAnchor, constant: 30).isActive = true
        tableView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: dividedLine.topAnchor, constant: 15.5).isActive = true

        dividedLine.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 16).isActive = true
        dividedLine.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -16).isActive = true
        dividedLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

        moreLabel.leadingAnchor.constraint(equalTo: dividedLine.leadingAnchor).isActive = true
        moreLabel.topAnchor.constraint(equalTo: dividedLine.bottomAnchor, constant: 17.5).isActive = true
        moreLabel.bottomAnchor.constraint(equalTo: backContentView.bottomAnchor, constant: -31).isActive = true

        moreButton.trailingAnchor.constraint(equalTo: dividedLine.trailingAnchor).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: moreLabel.centerYAnchor).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }

    func configure( news: [News]) {
        self.news = news
    }

}

extension HomeDetailNewsListCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailNewsCell.reuseIdentifier, for: indexPath) as? HomeDetailNewsCell else { return UITableViewCell() }
        let new = news[indexPath.row]
        cell.configure(news: new)
        //dummy
        cell.thumbnailImageView.image = UIImage(named: new.imageURL + "\(indexPath.row + 1)" )
        return cell
    }

}
