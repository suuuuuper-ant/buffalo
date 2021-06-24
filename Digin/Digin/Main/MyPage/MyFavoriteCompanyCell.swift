//
//  MyFavoriteCompanyCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/06/19.
//

import UIKit

class MyFavoriteCompanyCell: UITableViewCell, ViewType {
    var tags: [StockType] = [.buy, .notRated, .neutral, .marketPerform, .hold, .sell]
    var isEditingMode: Bool = false

    lazy var cornerBackGroundView: UIView = {
        let cornerBackGround = UIView()
        cornerBackGround.layer.cornerRadius = 20
        cornerBackGround.clipsToBounds = true
        cornerBackGround.backgroundColor = AppColor.lightgray249.color
        return cornerBackGround
    }()

    lazy var tableView: ContentSizedTableView = {
        let table = ContentSizedTableView(frame: .zero)
        table.dataSource = self
        table.estimatedRowHeight = 50
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.register(MyFavoriteDetailCell.self, forCellReuseIdentifier: MyFavoriteDetailCell.reuseIdentifier)
        table.register(MyFavoriteDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: MyFavoriteDetailHeaderView.reuseIdentifier)
        table.register(MyFavoriteEditDetailCell.self, forCellReuseIdentifier: MyFavoriteEditDetailCell.reuseIdentifier)
        table.isScrollEnabled = false
        return table
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraint()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
      //  tableView.reloadData()
    }

    func setupUI() {
        [cornerBackGroundView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        cornerBackGroundView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    func configure() {
//        self.tableView.sizeToFit()
    }

    func setupConstraint() {
        cornerBackGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28).isActive = true
        cornerBackGroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true
        cornerBackGroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cornerBackGroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        // tableView
        tableView.leadingAnchor.constraint(equalTo: cornerBackGroundView.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: cornerBackGroundView.trailingAnchor, constant: -20).isActive = true
        tableView.topAnchor.constraint(equalTo: cornerBackGroundView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: cornerBackGroundView.bottomAnchor).isActive = true

    }

}

extension MyFavoriteCompanyCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isEditingMode {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoriteEditDetailCell.reuseIdentifier) as? MyFavoriteEditDetailCell else {
            return UITableViewCell()
            }
            cell.companyLabel.text = "\(indexPath.row)"
          return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyFavoriteDetailCell.reuseIdentifier) as? MyFavoriteDetailCell else {
            return UITableViewCell()
            }
            cell.tagLabel.text = tags[indexPath.row].rawValue
            cell.companyLabel.text = "\(indexPath.row)"
            cell.tagLabel.textColor = tags[indexPath.row].colorForType()
            cell.tagLabel.layer.borderColor = tags[indexPath.row].colorForType().cgColor
            return cell
        }

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyFavoriteDetailHeaderView.reuseIdentifier) as? MyFavoriteDetailHeaderView
        if isEditingMode {
            headerView?.contentView.backgroundColor = .white

        } else {
            headerView?.contentView.backgroundColor = AppColor.lightgray249.color

        }
        return headerView
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
             completion(true)

        }
        return UISwipeActionsConfiguration(actions: [delete])

    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
//        if isEditingMode {
//            header?.contentView.backgroundColor = .white
//
//        } else {
//            header?.contentView.backgroundColor = .white
//
//        }
    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
//
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }

     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //let movedObject = items[sourceIndexPath.row]
       // items.remove(at: sourceIndexPath.row)
    // items.insert(movedObject, at: destinationIndexPath.row)
    }

}

final class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            print("contentSize \(contentSize)")
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: contentSize.width, height: contentSize.height)
    }
}
