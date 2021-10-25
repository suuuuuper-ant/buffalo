//
//  HomeGridCellNewsView.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/04.
//

import UIKit

class NewsArea: UIView, UITableViewDataSource, UITableViewDelegate {

    var news: [HomeNews] = [] {
        didSet {
            newsTableView.reloadData()
        }
    }

    lazy var newsTableView: UITableView = {
        let news = UITableView()
        news.delegate = self
        news.dataSource = self
        news.isScrollEnabled = false
        news.register(HomeNewsCell.self, forCellReuseIdentifier: HomeNewsCell.reuseIdentifier)
        return news
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

    lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.init(named: "divider_color")
        return divider

    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubview(newsTableView)
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        newsTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        newsTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        newsTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false

        divider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        let dividerCostraints = divider.topAnchor.constraint(equalTo: newsTableView.bottomAnchor, constant: 4.5)
        dividerCostraints.priority = .defaultLow
        dividerCostraints.isActive = true

        addSubview(moreLabel)
        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        moreLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        moreLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16.5).isActive = true
        moreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -31).isActive = true

        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.centerYAnchor.constraint(equalTo: moreLabel.centerYAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeNewsCell = tableView.dequeueReusableCell(withIdentifier: HomeNewsCell.reuseIdentifier) as? HomeNewsCell
        let news = self.news[indexPath.section]
       // homeNewsCell?.configure(news: news)
        homeNewsCell?.selectionStyle = .none
        return homeNewsCell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentedViewController = UIApplication.topViewController()
        let reportVIew = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController
        reportVIew.newsURL = news[indexPath.row].link
        reportVIew.modalPresentationStyle = .formSheet
        presentedViewController?.present(reportVIew, animated: true, completion: nil)
        print("\(indexPath)")
    }

}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
