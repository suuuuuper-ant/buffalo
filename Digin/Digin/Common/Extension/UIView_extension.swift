//
//  UIView_extension.swift
//  Digin
//
//  Created by 김예은 on 2021/04/05.
//

import Foundation
import UIKit

extension UIView {

    // MARK: 뷰 라운드 처리 설정
    func makeRounded(cornerRadius: CGFloat?) {
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
        } else {
            self.layer.cornerRadius = self.layer.frame.height / 2
        }

        self.layer.masksToBounds = true
    }

    // MARK: 뷰 원형 처리 설정
    func makeCircle() {
       self.layer.masksToBounds = true
       self.layer.cornerRadius = self.frame.width / 2
    }

    // MARK: 뷰 테두리 설정
    func makeBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

    // MARK: 뷰 그림자 설정
    // - color: 색상, opacity: 그림자 투명도, offset: 그림자 위치, radius: 그림자 크기
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
            layer.masksToBounds = false
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = opacity
            layer.shadowOffset = offSet
            layer.shadowRadius = radius

            layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIView {

    func fittingView(_ toView: UIView) {
        self.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
    }
}
