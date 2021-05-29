//
//  NoticeDetailsViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/28.
//

import UIKit

class NoticeDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        setBackBtn(color: AppColor.darkgray62.color)

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension NoticeDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeDetailsTableViewCell.reuseIdentifier) as? NoticeDetailsTableViewCell else {
            return UITableViewCell()
        }

        return cell
    }
}
