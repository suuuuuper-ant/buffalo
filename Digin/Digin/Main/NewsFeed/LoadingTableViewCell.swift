//
//  LoadingTableViewCell.swift
//  Digin
//
//  Created by 김예은 on 2021/05/13.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    func start() {
        activityIndicatorView.startAnimating()
    }
}
