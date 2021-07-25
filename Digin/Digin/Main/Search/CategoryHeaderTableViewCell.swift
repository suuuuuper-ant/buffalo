//
//  CategoryHeaderTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/03.
//

import UIKit

class CategoryHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var topC: NSLayoutConstraint!

    var nextClosure: (() -> Void)?

    @IBAction func nextAction(_ sender: UIButton) {
        self.nextClosure?()
    }
}
