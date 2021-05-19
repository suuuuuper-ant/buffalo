//
//  SearchViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineViewLeadingC: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldLeadingC: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!

    var isSearch = 0 //화면 전환 상태 (0: 메인, 1: 검색리스트, 2: 검색 결과)
    var hasSearchResult = false //검색 결과 유무

    //networking data
    var searchData = SearchResult()

    //local data
    let request = NSFetchRequest<NSManagedObject>(entityName: "RecentCompany")
    var recentCompany: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: CoreData - Fetch
        recentCompany =  PersistenceManager.shared.fetch(request: request)
        setup()
    }

    private func setup() {
        searchButton.isHidden = true
        searchTextField.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension

        let nibName = UINib(nibName: NoneResultTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: NoneResultTableViewCell.reuseIdentifier)
    }

    //검색 활성화
    @IBAction func startSearch(_ sender: UITextField) {
        // MARK: CoreData - Fetch
        recentCompany =  PersistenceManager.shared.fetch(request: request)

        isSearch = 1
        tableView.reloadData()

        //검색 활성화 animation
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.lineViewLeadingC.constant = -10
        }) { (_) in

            UIView.animate(withDuration: 2.0, delay: 1.0, animations: {
                self.textFieldLeadingC.constant = 20
                self.searchButton.isHidden = false
            })
        }
    }

    //검색
    @IBAction func searchAction(_ sender: UIButton) {
        if isTextEmpty() { return } //공백 체크

        // MARK: CoreData - Insert
        if let text = searchTextField.text {
            PersistenceManager.shared.insertCompany(name: text)
        }

        isSearch = 2
        searchTextField.resignFirstResponder()
        getSearchData()

        //검색 비활성화 animation
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.lineViewLeadingC.constant = 20
        }) { (_) in

            UIView.animate(withDuration: 2.0, delay: 2.0, animations: {
                self.textFieldLeadingC.constant = 30
            })
        }
    }

    private func isTextEmpty() -> Bool {
        if searchTextField.text == "" {
            self.alert(title: "", message: "검색어를 입력해주세요")
            return true
        }

        return false
    }
}

// MARK: - TextField
extension SearchViewController: UITextFieldDelegate {

    //FIXME : 동작 수정
    func textFieldShouldReturn(_ sender: UITextField) -> Bool {
        sender.resignFirstResponder()

        if isSearch == 1 { //검색창
            isSearch = 0
            searchTextField.text = ""
        }

        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.lineViewLeadingC.constant = 20

        }) { (_) in

            UIView.animate(withDuration: 2.0, delay: 2.0, animations: {
                self.textFieldLeadingC.constant = 30
                self.searchButton.isHidden = true
            })
        }

        tableView.reloadData()

        return true
    }
}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch == 1 { return 1 } //검색창
        if isSearch == 2 { //검색 결과
            if !hasSearchResult { return 1 }
            return 3
        }

        return 2 //메인
    }

    // - HEADER
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        switch isSearch {

        case 1: //검색창
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHeaderTableViewCell.reuseIdentifier) as? SearchHeaderTableViewCell else {
                return UITableViewCell()
            }

            cell.deleteClosure = { [weak self] in

                if let req = self?.request {
                    let cnt = PersistenceManager.shared.count(request: req) ?? 0

                    if cnt > 0 {
                        // MARK: CoreData - Delete All
                        PersistenceManager.shared.deleteAll(request: req)
                        // MARK: CoreData - Fetch
                        self?.recentCompany =  PersistenceManager.shared.fetch(request: req)
                    }
                }

                self?.tableView.reloadData()
            }

            return cell

        case 2: //검색 결과
            if !hasSearchResult { return UITableViewCell() }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryHeaderTableViewCell.reuseIdentifier) as? CategoryHeaderTableViewCell else {
                return UITableViewCell()
            }

            if section == 0 {
                cell.titleLabel.text = "기업"
                cell.nextButton.isHidden = true
                cell.timeLabel.isHidden = true

            } else if section == 1 {
                cell.titleLabel.text = "뉴스"
                cell.timeLabel.isHidden = true
                cell.nextButton.isHidden = false

                cell.nextClosure = { [weak self] in //뉴스 더보기
                    let newsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(identifier: SearchNewsfeedViewController.reuseIdentifier) as SearchNewsfeedViewController

                    guard let searchText = self?.searchTextField.text else { return }
                    newsVC.type = 0
                    newsVC.header = searchText

                    if let data = self?.searchData.news {
                        newsVC.newsData = data
                    }

                    self?.present(newsVC, animated: true, completion: nil) //Push
                }

            } else {
                cell.titleLabel.text = "카테고리"
                cell.nextButton.isHidden = true
                cell.timeLabel.isHidden = true
            }

            return cell

        default: //메인
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryHeaderTableViewCell.reuseIdentifier) as? CategoryHeaderTableViewCell else {
                return UITableViewCell()
            }

            if section == 0 {
                cell.titleLabel.text = "카테고리"
                cell.timeLabel.isHidden = true
                cell.nextButton.isHidden = true

            } else {
                cell.titleLabel.text = "인기 검색 기업"
                cell.timeLabel.isHidden = false
                cell.timeLabel.text = "21:03"
                cell.nextButton.isHidden = true
            }

            return cell
        }

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearch == 2 && !hasSearchResult { return 257 }
        return UITableView.automaticDimension
    }

    //- ROW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch isSearch {
        case 1: return recentCompany.count //검색 리스트

        case 2: //검색 결과
            if !hasSearchResult { return 1 } //검색 결과 없음

            if section == 0 { return searchData.companies.count } //기업
            if section == 1 { //뉴스
                if searchData.news.count >= 3 { return 3 }
                return searchData.news.count
            }
            return 1 //카테고리

        default: //메인
            if section == 0 { return 1 }
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch isSearch {

        case 1: //검색 리스트
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier) as? SearchTableViewCell else {
                return UITableViewCell()
            }

            let company: NSManagedObject = recentCompany[indexPath.row]
            cell.titleLabel.text = company.value(forKey: "name") as? String
            cell.layer.borderColor = AppColor.darkgray62.color.cgColor

            cell.deleteClosure = { [weak self] in

                if let req = self?.request {
                    let cnt = PersistenceManager.shared.count(request: req) ?? 0

                    guard let value = self?.recentCompany[indexPath.row] else { return }
                    if cnt > 0 {
                        // MARK: CoreData - Delete
                        PersistenceManager.shared.delete(object: value)
                        // MARK: CoreData - Fetch
                        self?.recentCompany =  PersistenceManager.shared.fetch(request: req)
                    }
                }
                self?.tableView.reloadData()
            }

            return cell

        case 2: //검색 결과

            if indexPath.section == 0 { //기업

                if !hasSearchResult { //검색 결과 없음
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: NoneResultTableViewCell.reuseIdentifier) as? NoneResultTableViewCell else {
                        return UITableViewCell()
                    }
                    return cell
                }

                guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.reuseIdentifier) as? CompanyTableViewCell else {
                    return UITableViewCell()
                }

                cell.titleLabel.text = searchData.companies[indexPath.row].name
                cell.categoryLabel.text = "커뮤니케이션 서비스"

                return cell
            }

            if indexPath.section == 1 { //뉴스
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyNewsTableViewCell.reuseIdentifier) as? CompanyNewsTableViewCell else {
                    return UITableViewCell()
                }

                cell.titleLabel.text = searchData.news[indexPath.row].title
                cell.dateLabel.text = searchData.news[indexPath.row].createdAt.setDate(format: "MM.dd. HH:mm")

                return cell
            }

            if indexPath.section == 2 { //카테고리
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier) as? CategoryTableViewCell else {
                    return UITableViewCell()
                }

                cell.collectionView.reloadData()
                cell.actionClosure = { [weak self] index in
                    print(index)
                    let detailsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: CategoryDetailsViewController.reuseIdentifier)
                    //TODO: 카테고리 index에 맞는 JSON 데이터 전달
                    self?.present(detailsVC, animated: true, completion: nil)
                }

                return cell
            }

        default: //메인
            if indexPath.section == 0 { //카테고리
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier) as? CategoryTableViewCell else {
                    return UITableViewCell()
                }

                cell.collectionView.reloadData()
                cell.actionClosure = { [weak self] index in
                    print(index)
                    let detailsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: CategoryDetailsViewController.reuseIdentifier)
                    //TODO: 카테고리 index에 맞는 JSON 데이터 전달
                    self?.present(detailsVC, animated: true, completion: nil)
                }

                return cell

            }

            //인기 검색 기업
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.reuseIdentifier) as? CompanyTableViewCell else {
                return UITableViewCell()
            }

            cell.titleLabel.text = "카카오"
            cell.categoryLabel.text = "커뮤니케이션 서비스"

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = HomeDetailViewController()

        switch isSearch {
        case 1: //검색 리스트
            //TODO: 기업 상세보기에 기업 index 전달하기
            self.present(detailsVC, animated: true, completion: nil)

        case 2: //검색 결과
            if indexPath.section == 0 { //기업
                //TODO: 기업 상세보기에 기업 index 전달하기
                self.present(detailsVC, animated: true, completion: nil)
            }

            if indexPath.section == 1 { //뉴스
                let detailVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController
                detailVC.newsURL = searchData.news[indexPath.row].link
                self.present(detailVC, animated: true, completion: nil)
            }

        default: //메인
            if indexPath.section == 1 {
                //TODO: 기업 상세보기에 기업 index 전달하기
                self.present(detailsVC, animated: true, completion: nil)
            }
        }

    }

}

// MARK: - Networking
extension SearchViewController {

    //TODO : 수정
    // GET - /news
    func getSearchData() {
        guard let text = searchTextField.text else { return }
        SearchService.getSearchData(searchText: text) { (result) in
            self.searchData = result
            print(self.searchData)
            DispatchQueue.main.async(execute: {

                if result.companies.isEmpty {
                    self.hasSearchResult = false
                } else {
                    self.hasSearchResult = true
                }

                self.tableView.reloadData()
            })
        }
    }
}
