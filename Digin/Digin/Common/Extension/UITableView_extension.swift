//
//  File.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/03.
//

import UIKit

extension UITableView {
    func updateHeaderViewHeight() {
        if let header = self.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(CGSize(width: self.bounds.width, height: 0))
            header.frame.size.height = newSize.height
        }
    }
}
