//
//  MyFavoriteViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/06/19.
//

import UIKit

class MyFavoriteViewController: UIViewController, ViewType {

    lazy var tableView: UITableView = {

        let table = UITableView(frame: .zero, style: .grouped)
        table.register(MyFavoriteCompanyCell.self, forCellReuseIdentifier: MyFavoriteCompanyCell.reuseIdentifier)
        table.register(MyFavoriteHeaderView.self, forHeaderFooterViewReuseIdentifier: MyFavoriteHeaderView.reuseIdentifier)
        table.estimatedRowHeight = 40
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.dataSource = self
        table.backgroundColor = .white
        return table
    }()

    lazy var previousButton: UIButton = {

        let previous = UIButton(type: .custom)
        previous.setImage( UIImage(named: "icon_navigation_back"), for: .normal)

        return previous
    }()

    lazy var titleLabel: UILabel = {

       let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .black
        title.text = "관심기업"
        return title
    }()

    var isEditMode: Bool = false
    lazy var editButton: UIButton = { [unowned self] in

       let edit = UIButton()
        edit.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        edit.setTitle("편집", for: .normal)
        edit.setTitleColor(AppColor.mainColor.color, for: .normal)
        edit.addTarget(self, action: #selector(editFavorites), for: .touchUpInside)
        return edit
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setupUI()
        self.setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {

        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraint() {
        tableView.fittingView(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cancelBarButton = UIBarButtonItem(customView: previousButton)
        let titleLabelBarButton = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItems = [cancelBarButton, titleLabelBarButton]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: editButton)]

        //네비바 커스텀
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    @objc func editFavorites(sender: UIButton) {
        self.isEditMode = !isEditMode
        if isEditMode {
            tableView.backgroundColor = AppColor.lightgray249.color

            self.editButton.setTitle("완료", for: .normal)
          //  self.tableView.setEditing(false, animated: true)
        } else {
            self.editButton.setTitle("편집", for: .normal)
            tableView.backgroundColor = .white
            //self.tableView.setEditing(true, animated: true)
        }

        self.navigationController?.navigationBar.barTintColor = isEditMode ? AppColor.lightgray249.color : .white

        self.tableView.reloadData()
    }
}

extension MyFavoriteViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoriteCompanyCell.reuseIdentifier) as? MyFavoriteCompanyCell else {
        return UITableViewCell()
        }

        //test
        if indexPath.section == 0 {

        }

        if self.isEditMode {

       //     cell.tableView.setEditing(true, animated: true)
            //cell.tableView.allowsSelectionDuringEditing = true

            cell.cornerBackGroundView.backgroundColor =  .white
            cell.contentView.backgroundColor = AppColor.lightgray249.color

        } else {
          //  cell.tableView.setEditing(false, animated: true)
           // cell.tableView.allowsSelectionDuringEditing = false
            cell.cornerBackGroundView.backgroundColor =  AppColor.lightgray249.color
            cell.contentView.backgroundColor = .white

        }
        cell.isEditingMode = self.isEditMode
        cell.tableView.reloadData()
        return cell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyFavoriteHeaderView.reuseIdentifier) as? MyFavoriteHeaderView

        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }

}
