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
    var header: String = ""
    var newsData = [SearchNews]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = .white
    }

    private func setup() {
        setBackBtn(color: AppColor.darkgray62.color)
        self.navigationController?.navigationBar.barTintColor = .white

        tableView.delegate = self
        tableView.dataSource = self

        let nibName = UINib(nibName: SearchNewsfeedTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: SearchNewsfeedTableViewCell.reuseIdentifier)

        titleLabel.text = header
    }
}

//FIXME: 카테고리 뉴스 api 추가 (API 없음)
// MARK: - TableView
extension SearchNewsfeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 0 { return newsData.count } //기업
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchNewsfeedTableViewCell.reuseIdentifier) as? SearchNewsfeedTableViewCell else {
            return UITableViewCell()
        }

        if type == 0 { //기업
            cell.titleLabel.text = newsData[indexPath.row].title
            cell.dateLabel.text = newsData[indexPath.row].createdAt.setDate(format: "MM.dd. HH:ss")
        } else { //카테고리
            cell.titleLabel.text = "‘지그재그’ 인수로 카카오가 기대하는 세 가지"
            cell.dateLabel.text = "05.06 17:24"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController

        if type == 0 { //기업
            webVC.newsURL = newsData[indexPath.row].link
        } else { //카테고리
            webVC.newsURL = "https://www.bloter.net/newsView/blt202105060019"
        }

        self.present(webVC, animated: true, completion: nil)
    }

}
