//
//  SearchViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lineViewLeadingC: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldLeadingC: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!

    var isSearch = 0 //화면 전환 상태 (0: 메인, 1: 검색리스트, 2: 검색 결과)

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        searchButton.isHidden = true
        searchTextField.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
    }

    //검색 활성화
    @IBAction func startSearch(_ sender: UITextField) {
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

        isSearch = 2
        searchTextField.resignFirstResponder()
        tableView.reloadData()

        //검색 비활성화 animation
        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseIn, animations: {
            self.lineViewLeadingC.constant = 20
        }) { (_) in

            UIView.animate(withDuration: 2.0, delay: 2.0, animations: {
                self.textFieldLeadingC.constant = 30
                self.searchButton.isHidden = true
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
        if isSearch == 2 { return 3 } //검색 결과

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
                //TODO: 검색어 전체 삭제 (내부 DB 사용)
                print("all delete")
            }

            return cell

        case 2: //검색 결과
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryHeaderTableViewCell.reuseIdentifier) as? CategoryHeaderTableViewCell else {
                return UITableViewCell()
            }

            if section == 0 {
                cell.titleLabel.text = "기업"
                cell.nextButton.isHidden = true
                cell.timeLabel.isHidden = false
                cell.timeLabel.text = "2021.05.10"
            } else if section == 1 {
                cell.titleLabel.text = "뉴스"
                cell.timeLabel.isHidden = true
                cell.nextButton.isHidden = false
                cell.nextClosure = { [weak self] in
                    guard let newsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(identifier: SearchNewsfeedViewController.reuseIdentifier) as? SearchNewsfeedViewController else { return }
                    //TODO: 카테고리 / 기업 구분해서 전달 (push)
                    self?.present(newsVC, animated: true, completion: nil)

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
        return UITableView.automaticDimension
    }

    //- ROW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch isSearch {
        case 1: return 3 //검색 리스트
        case 2: //검색 결과
            if section == 0 { return 5 }
            if section == 1 { return 3 }
            return 1

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

            cell.titleLabel.text = "카카오"
            cell.layer.borderColor = UIColor.appColor(.black62).cgColor

            cell.deleteClosure = { [weak self] in
                //TODO: 검색어 삭제 (내부 DB 사용)
                //indexPath.row -> delete
                print("delete")
            }

            return cell

        case 2: //검색 결과
            if indexPath.section == 0 { //기업
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.reuseIdentifier) as? CompanyTableViewCell else {
                    return UITableViewCell()
                }

                cell.titleLabel.text = "카카오"
                cell.categoryLabel.text = "커뮤니케이션 서비스"

                return cell
            }

            if indexPath.section == 1 { //뉴스
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyNewsTableViewCell.reuseIdentifier) as? CompanyNewsTableViewCell else {
                    return UITableViewCell()
                }

                cell.titleLabel.text = "[단독] 이찌안 귀엽다고 소리 지른 20대 여성 두명 붙잡혀..."
                cell.dateLabel.text = "연합뉴스 | 04. 17. 19:14"

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
                let detailVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier)
                //TODO: 뉴스 url 전달하기
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
