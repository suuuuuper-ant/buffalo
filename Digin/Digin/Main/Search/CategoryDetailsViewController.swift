//
//  CategoryDetailsViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/10.
//

import UIKit
import Kingfisher

class CategoryDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!

    var categoryReult = CategoryResult() //현재 카테고리 데이터
    var categoryData = [CategoryResult]() //전체 카테고리 데이터

    let dummyData = [["KB금융", "https://w.namu.la/s/c467dfd9f32771398f6b40fe64b7d394d8198872d0a3f0c9e5ebeea788a8c612770f7843c9b03e60d2b4a36921ee5535d5cd4f00d6430b8dfc483b532e897cf27675121d19d35e9de1d429b0c3aa936f557d09a5d8fb9eb1db75b80a6b151410", "Hold"],
    ["신한지주", "https://d32gkk464bsqbe.cloudfront.net/company-profiles/o/e604778422a0a9bd7852b3b142d04836b45801e7.png?v=6.4.4", "Marketperform"],
    ["삼성생명", "https://www.samsung.com/sec/static/etc/designs/smg/global/imgs/logo-square-letter.png", "Hold"], ["하나금융지주", "https://tistory2.daumcdn.net/tistory/1464752/attach/a4f69d91512142089ec6bcae50a0f672", "Buy"], ["삼성화재", "https://www.samsung.com/sec/static/etc/designs/smg/global/imgs/logo-square-letter.png", "Neutral"]]

    let newsData = [["KB금융지주, 1천100억원 녹색채권 발행…`국내 금융지주사 최초`", "https://www.mk.co.kr/news/economy/view/2021/05/516273/", "https://file.mk.co.kr/meet/yonhap/2021/05/28/image_readtop_2021_516273_0_151212.jpg", "05.28 15:11"],
                    ["신한지주, 5억달러 규모 ‘지속가능채권’ 발행 성공", "http://www.lcnews.co.kr/news/articleView.html?idxno=17423", "https://cdn.lcnews.co.kr/news/photo/202105/17423_18103_2216.jpg", "05.06 11:23"],
                    ["[단독]하나금융도 참전...5대 금융지주 'OO페이' 사활", "https://www.etnews.com/20210504000169", "https://img.etnews.com/photonews/2105/1410372_20210505154917_024_0001.jpg", "05.05"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = UIColor.appColor(.bgLightGrey)
        tableView.setContentOffset(.zero, animated: true)
    }

    private func setup() {
        setBackBtn(color: AppColor.darkgray62.color)
        self.navigationController?.navigationBar.barTintColor = UIColor.appColor(.bgLightGrey)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension

        titleLabel.text = categoryReult.name
        introLabel.text = categoryReult.contents
        logoImageView.image = UIImage(named: categoryReult.bigImg)
    }

}

//TODO: 카테고리 뉴스 api 통신 (API 없음)
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
            let today = NSDate() //현재 시각 구하기
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy. MM. dd"
            let dateString = dateFormatter.string(from: today as Date)
            cell.dateLabel.text = dateString

            cell.nextButton.isHidden = true
        }

        if section == 1 { //뉴스
            cell.titleLabel.text = "뉴스"
            cell.dateLabel.isHidden = true
            cell.nextButton.isHidden = true
            cell.nextClosure = { [weak self] in
                guard let newsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(identifier: SearchNewsfeedViewController.reuseIdentifier) as? SearchNewsfeedViewController else { return }
                newsVC.type = 1
                newsVC.header = self?.categoryReult.name ?? ""
                self?.navigationController?.pushViewController(newsVC, animated: true)
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
        if section == 0 { return dummyData.count }
        if section == 1 { return newsData.count }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { //기업별 순위
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCompanyTableViewCell.reuseIdentifier) as? DetailsCompanyTableViewCell else {
                return UITableViewCell()
            }

            if indexPath.row == 0 {
                cell.topC.constant = 15
            } else {
                cell.topC.constant = 10
            }

            cell.titleLabel.text = dummyData[indexPath.row][0]
            let url = URL(string: dummyData[indexPath.row][1])
            cell.logoImageView.kf.setImage(with: url, placeholder: UIImage())

            let category = dummyData[indexPath.row][2]
            if category == "Marketperform" {
                cell.categoryLabel.textColor = AppColor.stockMarketperform.color
                cell.categoryLabel.layer.borderColor = AppColor.stockMarketperform.color.cgColor
            } else if category == "Hold" {
                cell.categoryLabel.textColor = AppColor.stockHold.color
                cell.categoryLabel.layer.borderColor = AppColor.stockHold.color.cgColor
            } else if category == "Neutral" {
                cell.categoryLabel.textColor = AppColor.stockNeutral.color
                cell.categoryLabel.layer.borderColor = AppColor.stockNeutral.color.cgColor
            } else if category == "Buy" {
                cell.categoryLabel.textColor = AppColor.stockSell.color
                cell.categoryLabel.layer.borderColor = AppColor.stockSell.color.cgColor
            } else {
                cell.categoryLabel.textColor = AppColor.stockNotRated.color
                cell.categoryLabel.layer.borderColor = AppColor.stockNotRated.color.cgColor
            }
            cell.categoryLabel.text = category

            cell.layer.borderColor = UIColor.appColor(.mainBlue).cgColor
            cell.categoryLabel.font = UIFont.englishFont(ofSize: 12)

            return cell
        }

        if indexPath.section == 1 { //뉴스
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsNewsTableViewCell.reuseIdentifier) as? DetailsNewsTableViewCell else {
                return UITableViewCell()
            }

            cell.titleLabel.text = newsData[indexPath.row][0]
            cell.dateLabel.text = newsData[indexPath.row][3]
            let url = URL(string: newsData[indexPath.row][2])
            cell.newsImageView.kf.setImage(with: url, placeholder: UIImage())

            return cell
        }

        //이 분야들은 어때요
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCategoryTableViewCell.reuseIdentifier) as? DetailsCategoryTableViewCell else {
            return UITableViewCell()
        }

        cell.collectionView.reloadData()
        cell.actionClosure = { [weak self] (result) in
            guard let detailsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: CategoryDetailsViewController.reuseIdentifier) as? CategoryDetailsViewController else { return }
            detailsVC.categoryReult = result
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        //    let detailsVC = HomeDetailViewController()
            //TODO: 기업 상세보기에 기업 index 전달하기 
          //  self.navigationController?.pushViewController(detailsVC, animated: true)
        }

        if indexPath.section == 1 { //뉴스
            let detailVC = UIStoryboard(name: "NewsFeed", bundle: nil).instantiateViewController(identifier: NewsDetailsViewController.reuseIdentifier) as NewsDetailsViewController
            //TODO: 뉴스 url 전달하기 (API 없음)
            detailVC.newsURL = newsData[indexPath.row][1]
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
