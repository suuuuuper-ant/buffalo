//
//  LaunchViewController.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/23.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController, ViewType {

    lazy var lottieImageView: AnimationView = {
        let animation = AnimationView(name: "LogoLottie")
        animation.contentMode = .scaleAspectFill
        return animation
    }()

    lazy var logoLabel: UILabel = {
        let logoLabel = UILabel()
        logoLabel.font = UIFont.englishFont(ofSize: 16)
        logoLabel.text = "DiGiN"
        logoLabel.textColor = .white
        return logoLabel
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.mainColor.color
        lottieImageView.play { [weak self] _ in

            UIView.animate(withDuration: 0.1) {
                self?.view.backgroundColor = .white
            } completion: { _ in
                self?.changeToScreen()
            }
        }
    }

    func setupUI() {
        [lottieImageView, logoLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraint() {
        // lottie
        lottieImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lottieImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 193).isActive = true
        lottieImageView.widthAnchor.constraint(equalToConstant: 107).isActive = true
        lottieImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true

        // LogoLabel
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -76).isActive = true
        logoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }

    func changeToScreen() {
        let sceneDelegate = SceneDelegate.getFirstScene()
        sceneDelegate?.goToStartPoint()
    }

    deinit {
        print("deinit Launch")
    }
}
