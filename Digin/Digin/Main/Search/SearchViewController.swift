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
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var textFieldLeadingC: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryHeaderTableViewCell.reuseIdentifier) as? CategoryHeaderTableViewCell else {
            return UITableViewCell()
        }

        if section == 0 {
            cell.titleLabel.text = "카테고리"
            cell.timeLabel.isHidden = true
        } else {
            cell.titleLabel.text = "인기 검색 기업"
            cell.timeLabel.isHidden = false
            cell.timeLabel.text = "시간"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier) as? CategoryTableViewCell else {
                return UITableViewCell()
            }

            cell.collectionView.reloadData()

            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyTableViewCell.reuseIdentifier) as? CompanyTableViewCell else {
                return UITableViewCell()
            }

            cell.titleLabel.text = "카카오"
            cell.categoryLabel.text = "커뮤니케이션 서비스"

            return cell
        }
    }

}
