//
//  SearchNewsfeedViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import UIKit

class SearchNewsfeedViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var type: Int = 0 //0: 기업, 1: 카테고리

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self

        let nibName = UINib(nibName: SearchNewsfeedTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: SearchNewsfeedTableViewCell.reuseIdentifier)

    }

}

// MARK: - TableView
extension SearchNewsfeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchNewsfeedTableViewCell.reuseIdentifier) as? SearchNewsfeedTableViewCell else {
            return UITableViewCell()
        }

        cell.titleLabel.text = "[단독] 이찌안 귀엽다고 소리 지른 20대 여성 두명 붙잡혀..."
        cell.dateLabel.text = "연합뉴스 | 04. 17. 19:14"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController
        webVC.newsURL = "" //TODO : url 데이터 전달
        self.present(webVC, animated: true, completion: nil)
    }

}
