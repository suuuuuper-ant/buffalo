//
//  UIViewController_extension.swift
//  Digin
//
//  Created by 김예은 on 2021/04/05.
//
import Foundation
import UIKit

extension UIViewController {

    // MARK: 커스텀 백버튼 설정
    func setBackBtn(color: UIColor) {

        //백버튼 이미지 파일 이름에 맞게 변경
        let backBtn = UIBarButtonItem(image: UIImage(named: "btBackarrow"),
            style: .plain,
            target: self,
            action: #selector(self.pop))

        navigationItem.leftBarButtonItem = backBtn
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }

    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: 뷰컨트롤러 parent 설정
@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
