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
        let backBtn = UIBarButtonItem(image: UIImage(named: "icon_navigation_back"),
            style: .plain,
            target: self,
            action: #selector(self.pop))

        backBtn.imageInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = backBtn
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }

    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: 네비게이션 바 투명하게 하는 함수
    func setNavigationBar() {
        let bar: UINavigationBar! = self.navigationController?.navigationBar

        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
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
