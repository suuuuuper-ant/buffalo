//
//  TermsAndConditionsViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/18.
//

import UIKit
import Combine

class SheetView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.topRight, .topLeft],
                                cornerRadii: CGSize(width: 30, height: 30))

        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

class TermsAndConditionsViewController: UIViewController, ViewType {
    var cancellables: Set<AnyCancellable> = []
    var sheetTopContraints: NSLayoutConstraint?

    lazy var termsAndConditionsLabel: UILabel = {

        let conditions = UILabel()
        conditions.text = "디긴 이용약관 동의"
        conditions.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return conditions
    }()

    var sheetHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.4
    }

    lazy var sheetView: SheetView = {

        let sheet = SheetView()
        sheet.backgroundColor = .white
        return sheet
    }()

    lazy var cancelButton: UIButton = {

        let cancel = UIButton()
        cancel.setImage(UIImage(named: "icon_cancel"), for: .normal)
        return cancel
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupConstraint()
        bindingUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sheetTopContraints?.constant = -sheetHeight

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func bindingUI() {

        cancelButton.tapPublisher.sink { [unowned self] _ in
            self.view.backgroundColor = .clear
            self.sheetTopContraints?.constant = 0

            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn]) {
                self.view.layoutIfNeeded()
                self.view.setNeedsDisplay()
            } completion: { [weak self] _ in
                self?.dismiss(animated: false)
            }

        }.store(in: &cancellables)
    }

    func setupUI() {
        view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
        view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false

        [termsAndConditionsLabel, cancelButton].forEach {

            sheetView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false

        }
    }

    func setupConstraint() {

        sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sheetView.heightAnchor.constraint(equalToConstant: sheetHeight).isActive = true

        sheetTopContraints = sheetView.topAnchor.constraint(equalTo: view.bottomAnchor)
        sheetTopContraints?.isActive = true

        termsAndConditionsLabel.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 20).isActive = true
        termsAndConditionsLabel.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 40).isActive = true
        termsAndConditionsLabel.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -20).isActive = true
        // cancel

        cancelButton.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: termsAndConditionsLabel.centerYAnchor).isActive = true

    }

}
