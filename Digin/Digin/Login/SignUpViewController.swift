//
//  SignViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/11.
//

import UIKit

class SignUpViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        view.addSubview(label)
        label.text = "\(String(describing: self))"
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
    }
}
