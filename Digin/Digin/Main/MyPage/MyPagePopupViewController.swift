//
//  MyPagePopupViewController.swift
//  Digin
//
//  Created by 김예은 on 2021/05/29.
//

import UIKit

class MyPagePopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var exitButton: UIButton!

    var popClosure: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        popupView.makeRounded(cornerRadius: 20)
        exitButton.roundCorners(cornerRadius: 20, maskedCorners: .layerMinXMaxYCorner)
        exitButton.roundCorners(cornerRadius: 20, maskedCorners: .layerMaxXMaxYCorner)
    }

    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func exitAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.popClosure?()
    }
}
