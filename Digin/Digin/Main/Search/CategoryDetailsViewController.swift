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

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension

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
                //TODO: 기업 인덱스 전달하기 (회의에서 상의하기)
                let tabVC = MainTabBarController()
                tabVC.selectedIndex = 2
                tabVC.modalPresentationStyle = .fullScreen
                self?.present(tabVC, animated: true, completion: nil)
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
        cell.actionClosure = { [weak self] index in
            print(index)
            let detailsVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: CategoryDetailsViewController.reuseIdentifier)
            //TODO: 카테고리 index에 맞는 JSON 데이터 전달
            self?.present(detailsVC, animated: true, completion: nil)
        }

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: 기업 상세보기에 기업 index 전달하기(진호) - push?
        let detailsVC = HomeDetailViewController()
        //FIXME: 네비바 처리 후, 변경
        self.present(detailsVC, animated: true, completion: nil)
    }

}
