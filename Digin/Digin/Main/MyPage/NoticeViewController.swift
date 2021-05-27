//
//  NoticeViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/27.
//

import UIKit

class NoticeViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var tableView: UITableView!

    var type = 0 // 공지사항 = 0, 약관 = 1

    let type1Data = ["이용약관", "개인정보처리방침"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        setBackBtn(color: AppColor.darkgray62.color)
        backView.makeRounded(cornerRadius: 20)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)

        let nibName1 = UINib(nibName: MyPageMainTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName1, forCellReuseIdentifier: MyPageMainTableViewCell.reuseIdentifier)

        let nibName2 = UINib(nibName: NoticeTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nibName2, forCellReuseIdentifier: NoticeTableViewCell.reuseIdentifier)

        if type == 0 {
            noticeLabel.text = "디긴이 드디어 오픈했어요!"
            logoImageView.image = UIImage(named: "random1")
            self.title = "공지사항"
        } else {
            noticeLabel.text = "꼼꼼하게 읽어보세요!"
            logoImageView.image = UIImage(named: "maskGroup")
            self.title = "약관 및 정책"
        }
    }

}

// MARK: - TableView
extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if type == 1 { //약관 및 정책
            return type1Data.count
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if type == 1 { //약관 및 정책
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMainTableViewCell.reuseIdentifier) as? MyPageMainTableViewCell else { return UITableViewCell()}

            cell.titleLabel.text = type1Data[indexPath.row]
            cell.accessoryType = .disclosureIndicator

            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.reuseIdentifier) as? NoticeTableViewCell else { return UITableViewCell()}

        cell.titleLabel.text = "디긴이 오픈했습니다!"
        cell.dateLabel.text = "2021.05.30"
        cell.accessoryType = .disclosureIndicator

        return cell
    }

}
