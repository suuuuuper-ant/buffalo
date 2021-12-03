//
//  SearchNewsfeedViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import UIKit
import Kingfisher

protocol SearchNewsfeedViewControllerPresenter {

    func updateList(list: [SearchNewsViewModel])

}

class SearchNewsfeedViewController: UIViewController, SearchNewsfeedViewControllerPresenter {

    var interator: SearchNewsInterator?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var newsList: [SearchNewsViewModel] = [] {
        didSet {

            self.tableView.reloadData()
        }
    }
    var type: Int = 0 //0: 검색, 1: 기업, 2: 카테고리

    var isLoad = false
    var header: String = "" //검색어/기업명/카테고리명

    // 0
    var newsData = [NewsDetail]() {
        didSet {
            self.isLoad = true
        }
    }//검색 모델

    // 1
    var companyNewsData = NewsfeedResult() //기업 모델
    var contents: [NewsfeedContent] = [NewsfeedContent]()
    var stockcode = "" //기업 코드 035420

    //Paging
    var currentPage = 0
    var hasNextPage = true
    var isPaging = false

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

       // if type == 1 {
            self.interator?.fetchNewsList(keyword: header)
       // }
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
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension

        let nibName = UINib(nibName: SearchNewsfeedTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: SearchNewsfeedTableViewCell.reuseIdentifier)

        //로딩 셀
        let nibName1 = UINib(nibName: LoadingTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName1, forCellReuseIdentifier: LoadingTableViewCell.reuseIdentifier)

        let nibName2 = UINib(nibName: NoneResultTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName2, forCellReuseIdentifier: NoneResultTableViewCell.reuseIdentifier)

        titleLabel.text = header
    }
}

//FIXME: 카테고리 뉴스 api 추가 (API 없음)
// MARK: - TableView
extension SearchNewsfeedViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if type == 1 && isPaging && hasNextPage { return 2 }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isLoad || newsData.isEmpty || companyNewsData.empty { return 1 }

        if type == 0 { return newsData.count } //검색
        if type == 1 { //기업

            if section == 1 { return 1 }
            return contents.count

        }
        if type == 2 { return 10 } //카테고리

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if !isLoad {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseIdentifier, for: indexPath) as? LoadingTableViewCell else { return UITableViewCell() }
            cell.start()
            return cell
        }

        if companyNewsData.empty || newsData.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoneResultTableViewCell.reuseIdentifier) as? NoneResultTableViewCell else { return UITableViewCell() }
            cell.contentLabel.text = "해당 기업의 뉴스가 없어요!"
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchNewsfeedTableViewCell.reuseIdentifier) as? SearchNewsfeedTableViewCell else {
            return UITableViewCell()
        }

        if type == 0 { //검색
            if !newsList.isEmpty {
                let viewModel = newsList[indexPath.row]
                cell.configure(viewModel: viewModel)
            }

//            cell.titleLabel.text = newsData[indexPath.row].title
//            cell.dateLabel.text = newsData[indexPath.row].createdAt.setDate(format: "MM.dd. HH:ss")
//            let url = URL(string: newsData[indexPath.row].imageUrl)
          //  cell.newsImageView.kf.setImage(with: url, placeholder: UIImage(named: "listNonePic"))
        } else if type == 1 { //기업

            if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseIdentifier, for: indexPath) as? LoadingTableViewCell else {
                    return UITableViewCell()
                }
                cell.start()
                return cell

            }
            cell.titleLabel.text = contents[indexPath.row].title
            cell.dateLabel.text = contents[indexPath.row].createdAt.setDate(format: "MM.dd. HH:ss")
            let url = URL(string: contents[indexPath.row].imageUrl)
            cell.newsImageView.kf.setImage(with: url, placeholder: UIImage(named: "listNonePic"))
        } else { //카테고리
            cell.titleLabel.text = "‘지그재그’ 인수로 카카오가 기대하는 세 가지"
            cell.dateLabel.text = "05.06 17:24"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController

        if type == 0 { //검색
        //    webVC.newsURL = newsData[indexPath.row].link
        } else if type == 1 {
            webVC.newsURL = contents[indexPath.row].link
        } else { //카테고리
            webVC.newsURL = "https://www.bloter.net/newsView/blt202105060019"
        }

        self.present(webVC, animated: true, completion: nil)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
        if offsetY > (contentHeight - height) {
            if isPaging == false && hasNextPage {
                currentPage += 1
                beginPaging()
            }
        }
    }

    func beginPaging() {
        isPaging = true // 현재 페이징이 진행 되는 것을 표시

        // Section 1을 reload하여 로딩 셀을 보여줌 (페이징 진행 중인 것을 확인할 수 있도록)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        // 페이징 메소드 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.type == 1 {
                self.getCompanyNews()
            }
        }
    }

    func updateList(list: [SearchNewsViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.newsList = list
        }

    }

}

extension SearchNewsfeedViewController {

    // GET - /companies/{stockCode}/news (기업 뉴스)
    func getCompanyNews() {
        NewsfeedService.getCompanyNews(stockCode: stockcode, pageNumber: currentPage) { (result) in

            self.companyNewsData = result

            if !result.empty {
                self.contents += result.content
            }

            if result.last { self.hasNextPage = false } //페이징 종료

            DispatchQueue.main.async {
                self.isLoad = true
                self.isPaging = false
                self.tableView.reloadData()
            }
        }
    }
}
