//
//  CategoryDetailsViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/10.
//

import UIKit

class CategoryDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!

    var categoryReult = CategoryResult() //현재 카테고리 데이터
    var categoryData = [CategoryResult]() //전체 카테고리 데이터

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension

        titleLabel.text = categoryReult.name
        introLabel.text = categoryReult.contents
        logoImageView.image = UIImage(named: categoryReult.bigImg)
    }

}

extension CategoryDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsHeaderTableViewCell.reuseIdentifier) as? DetailsHeaderTableViewCell else {
            return UITableViewCell()
        }

        if section == 0 {
            cell.titleLabel.text = "기업별 순위"
            cell.dateLabel.isHidden = false
            cell.dateLabel.text = "2021. 04. 30"
            cell.nextButton.isHidden = true
        }

        if section == 1 { //뉴스
            cell.titleLabel.text = "뉴스"
            cell.dateLabel.isHidden = true
            cell.nextButton.isHidden = false
            cell.nextClosure = { [weak self] in
                guard let newsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(identifier: SearchNewsfeedViewController.reuseIdentifier) as? SearchNewsfeedViewController else { return }
                //TODO: 카테고리 / 기업 구분해서 전달 (push)
                self?.present(newsVC, animated: true, completion: nil)
            }
        }

        if section == 2 {
            cell.titleLabel.text = "이 분야들은 어때요?"
            cell.dateLabel.isHidden = true
            cell.nextButton.isHidden = true
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 10 }
        if section == 1 { return 3 }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { //기업별 순위
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCompanyTableViewCell.reuseIdentifier) as? DetailsCompanyTableViewCell else {
                return UITableViewCell()
            }

            cell.titleLabel.text = "카카오"
            cell.layer.borderColor = UIColor.appColor(.mainBlue).cgColor
            cell.categoryLabel.font = UIFont.englishFont(ofSize: 12)

            return cell
        }

        if indexPath.section == 1 { //뉴스
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsNewsTableViewCell.reuseIdentifier) as? DetailsNewsTableViewCell else {
                return UITableViewCell()
            }

            cell.titleLabel.text = "[단독] 이찌안 귀엽다고 소리 지른 20대 여성 두명 붙잡혀..."
            cell.dateLabel.text = "연합뉴스 | 04. 17. 19:14"

            return cell
        }

        //이 분야들은 어때요
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCategoryTableViewCell.reuseIdentifier) as? DetailsCategoryTableViewCell else {
            return UITableViewCell()
        }

        cell.collectionView.reloadData()
        cell.actionClosure = { [weak self] (result) in
            guard let detailsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: CategoryDetailsViewController.reuseIdentifier) as? CategoryDetailsViewController else { return }
            //TODO: 카테고리 index에 맞는 JSON 데이터 전달
            detailsVC.categoryReult = result
            self?.present(detailsVC, animated: true, completion: nil)
        }

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let detailsVC = HomeDetailViewController()
            //TODO: 기업 상세보기에 기업 index 전달하기 
            self.present(detailsVC, animated: true, completion: nil)
        }

        if indexPath.section == 1 { //뉴스
            let detailVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier)
            //TODO: 뉴스 url 전달하기
            self.present(detailVC, animated: true, completion: nil)
        }
    }

}

// MARK: - Networking
extension CategoryDetailsViewController {

    //카테고리 데이터 로드
    func getCategoryData() {

        CategoryService.getCategory { (result) in
            self.categoryData = result
            self.tableView.reloadData()
        }
    }
}
