//
//  CustomSegmentedControl.swift
//  Digin
//
//  Created by 김예은 on 2021/04/28.
//

import UIKit

extension UISegmentedControl {

    func removeBorder() {
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)

        let nomalTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.lightGrey1),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        let seletedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.appColor(.black62),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        self.setTitleTextAttributes(nomalTextAttributes, for: .normal)
        self.setTitleTextAttributes(seletedTextAttributes, for: .selected)
    }

    func addUnderlineForSelectedSegment() {
        removeBorder()

        let underlineWidth: CGFloat = self.bounds.size.width / (CGFloat(self.numberOfSegments)) //0.2
        let underlineHeight: CGFloat = 3
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight) //7

        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.appColor(.black62)
        underline.tag = 1

        self.addSubview(underline)
    }

    func changeUnderlinePosition() {
        guard let underline = self.viewWithTag(1) else { return }
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)

        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage {

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)

        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)

        guard let rectangleImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()

        return rectangleImage
    }
}
