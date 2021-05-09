//
//  DetailsHeaderTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/10.
//

import UIKit

class DetailsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    var nextClosure: (() -> Void)?

    @IBAction func nextAction(_ sender: UIButton) {
        self.nextClosure?()
    }

}
