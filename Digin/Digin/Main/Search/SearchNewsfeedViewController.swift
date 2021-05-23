//
//  SearchNewsfeedViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import UIKit

class SearchNewsfeedViewController: UIViewController {

    @IBOutlet weak var titleLabelTopC: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var type: Int = 0 //0: 기업, 1: 카테고리
    var header: String = ""
    var newsData = [SearchNews]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setNavigationBar()
    }

    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self

        let nibName = UINib(nibName: SearchNewsfeedTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: SearchNewsfeedTableViewCell.reuseIdentifier)

        titleLabel.text = header
    }

    private func setNavigationBar() {
        let topInset: CGFloat = UIApplication.shared.statusBarFrame.height
        titleLabelTopC.constant += topInset

        let navBar = UINavigationBar(frame: CGRect(x: 0, y: topInset, width: view.frame.size.width, height: 44))
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        view.addSubview(navBar)

        let navItem = UINavigationItem()
        let backBTN = UIBarButtonItem(image: UIImage(named: "icon_navigation_back"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(backAction))
        navItem.leftBarButtonItem = backBTN
        backBTN.tintColor = AppColor.darkgray62.color
        backBTN.imageInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        navBar.setItems([navItem], animated: false)
    }

    @objc func backAction() {
        self.dismiss(animated: false, completion: nil)
    }

}

// MARK: - TableView
extension SearchNewsfeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchNewsfeedTableViewCell.reuseIdentifier) as? SearchNewsfeedTableViewCell else {
            return UITableViewCell()
        }

        cell.titleLabel.text = newsData[indexPath.row].title
        cell.dateLabel.text = newsData[indexPath.row].createdAt.setDate(format: "MM.dd. HH:ss")

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController
        webVC.newsURL = newsData[indexPath.row].link
        self.present(webVC, animated: true, completion: nil)
    }

}
