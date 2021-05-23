//
//  SignInputFieldView.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/14.
//

import UIKit

struct SignInputFieldViewModel {
    var font: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    var lineColor: UIColor = AppColor.mainColor.color
    var leftButtonImage: UIImage?
    var placeholder: String = ""

}
class SignInputFieldView: UIView, ViewType {

    var viewModel: SignInputFieldViewModel = SignInputFieldViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(_ viewModel: SignInputFieldViewModel, frame: CGRect = .zero) {
        self.init(frame: frame)
        self.viewModel = viewModel
        setupUI()
        setupConstraint()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var textField: UITextField = {
        let input = UITextField()
        input.font = viewModel.font
        input.placeholder = viewModel.placeholder
        return input
    }()

    lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = AppColor.gray160.color
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.textColor = AppColor.stockRed.color
        description.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return description
    }()
    lazy var totalStackView: UIStackView = {
        let totalStackView = UIStackView()
        totalStackView.spacing = 6
        totalStackView.axis = .vertical
        return totalStackView
    }()

    lazy var textFieldButton: UIButton = {
        let input = UIButton()
        input.setImage(viewModel.leftButtonImage, for: .normal)
        input.imageView?.contentMode = .scaleAspectFill
        input.isHidden = viewModel.leftButtonImage == nil ? true : false
        return input
    }()

    func setupUI() {
        let textAreaStackView = UIStackView()
        textAreaStackView.axis = .horizontal
        textAreaStackView.spacing = 9
        textAreaStackView.addArrangedSubview(textField)
        textAreaStackView.addArrangedSubview(textFieldButton)
        textFieldButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(totalStackView)
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.addArrangedSubview(textAreaStackView)
        stackView.addArrangedSubview(lineView)

        totalStackView.addArrangedSubview(stackView)
        totalStackView.addArrangedSubview(descriptionLabel)

    }

    func setupConstraint() {
        totalStackView.fittingView(self)

        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        textFieldButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }

}
