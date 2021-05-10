//
//  SearchHeaderTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/03.
//

import UIKit

class SearchHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    var deleteClosure: (() -> Void)?

    @IBAction func deleteAction(_ sender: UIButton) {
        self.deleteClosure?()
    }
}
