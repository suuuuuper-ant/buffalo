//
//  HomeDetailBarChartCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/07.
//

import UIKit

class HomeDetailBarChartCell: UITableViewCell, ViewType {
    var viewModel: HomeDetailViewModel?
    struct UI {
        static let totalHeight: CGFloat = 323
        static let topHeight: CGFloat =  90
        static let chartHeight: CGFloat =  90
        static let bottomHeight: CGFloat =  70
        static let yearArea: CGFloat = 17
        static let expandHeight: CGFloat = 40
    }
    // 따로 뷰로 뺴내기

    lazy var salesInfoView: UIView  = {

        let sales = UIView()
        let dot = UIView()
        sales.addSubview(dot)
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.widthAnchor.constraint(equalToConstant: 6).isActive = true
        dot.heightAnchor.constraint(equalToConstant: 6).isActive = true
        dot.leadingAnchor.constraint(equalTo: sales.leadingAnchor).isActive = true
        dot.centerYAnchor.constraint(equalTo: sales.centerYAnchor).isActive = true
        dot.backgroundColor = AppColor.darkgray82.color
        dot.makeRounded(cornerRadius: 3)

        let title = UILabel()
        title.text = "매출액"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = AppColor.darkgray82.color
        title.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        sales.addSubview(title)
        title.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 3).isActive = true
        title.centerYAnchor.constraint(equalTo: sales.centerYAnchor).isActive = true
        return sales

    }()

    lazy var profitInfoView: UIView  = {

        let sales = UIView()
        let dot = UIView()
        sales.addSubview(dot)
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.widthAnchor.constraint(equalToConstant: 6).isActive = true
        dot.heightAnchor.constraint(equalToConstant: 6).isActive = true
        dot.leadingAnchor.constraint(equalTo: sales.leadingAnchor).isActive = true
        dot.centerYAnchor.constraint(equalTo: sales.centerYAnchor).isActive = true
        dot.backgroundColor = AppColor.gray160.color
        dot.makeRounded(cornerRadius: 3)

        let title = UILabel()
        title.text = "영업이익"
        title.textColor = AppColor.gray160.color
        title.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        sales.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 3).isActive = true
        title.centerYAnchor.constraint(equalTo: sales.centerYAnchor).isActive = true

        return sales

    }()

    lazy var yearButton: UIButton = {
        let year = UIButton()
        year.setTitle("연간", for: .normal)
        year.setTitleColor(AppColor.darkgray62.color, for: .normal)
        year.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        year.isSelected = true
        year.tag = 99
        return year
    }()

    lazy var quaterButton: UIButton = {
        let quaterButton = UIButton()
        quaterButton.setTitle("분기별", for: .normal)
        quaterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        quaterButton.setTitleColor(AppColor.gray160.color, for: .normal)
        quaterButton.tag = 100
        return quaterButton
    }()

    lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 7
        stack.addArrangedSubview(yearButton)
        stack.addArrangedSubview(quaterButton)
        return stack
    }()

    lazy var backContentView: UIView = {
        let content = UIView()
        content.makeRounded(cornerRadius: 15)
        content.backgroundColor = .white
        return content
    }()

    lazy var barchartStackView: UIStackView = {

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return stackView
    }()

    var preriodType: PeriodType = .year

    enum PeriodType {
        case year
        case quater
    }

    lazy var charGraphView: UIView = {
        let chartView = UIView()
        return chartView
    }()

    lazy var infoView = UIView()
    lazy var bottomView: UIView = {
        let bottom = UIView()
        return bottom
    }()

    lazy var yearView: UIView = {
        let bottom = UIView()
        return bottom
    }()

    lazy var indicatorView: UIView = {
        let indicator = UIView()
        indicator.backgroundColor = AppColor.darkgray62.color
        return indicator
    }()

   lazy var standardView: UIView =  {
        let standard = UIView()
//        standard.backgroundColor = AppColor.gray225.color
//        standard.translatesAutoresizingMaskIntoConstraints = false
//        charGraphView.addSubview(standardView)
        return standard
    }()
    var isButtonClicked: Bool = false

    var indicatorLeading: NSLayoutConstraint?
    var indicatorWidth: NSLayoutConstraint?

    lazy var infoStackView: UIStackView = {
        let info = UIStackView()
        info.axis = .horizontal
        info.spacing = 8
        return info
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraint()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        contentView.backgroundColor = UIColor.init(named: "home_background")
        contentView.addSubview(backContentView)
        backContentView.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView(image: UIImage(named: "bottom_character"))

        backContentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.fittingView(backContentView)

        [infoView, charGraphView, yearView, bottomView].forEach {
            backContentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        bottomView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        buttonStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -50).isActive = true

        buttonStackView.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorLeading = indicatorView.leadingAnchor.constraint(equalTo: yearButton.leadingAnchor)
        indicatorLeading?.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorWidth = indicatorView.widthAnchor.constraint(equalToConstant: 28)
        indicatorWidth?.isActive = true
        indicatorView.topAnchor.constraint(equalTo: yearButton.bottomAnchor, constant: 1).isActive = true

        infoView.addSubview(salesInfoView)
        infoView.addSubview(profitInfoView)
        salesInfoView.translatesAutoresizingMaskIntoConstraints = false
        profitInfoView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraint() {

        backContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        backContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        backContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        backContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        infoView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: backContentView.topAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: UI.topHeight).isActive = true

        let leading = charGraphView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        leading.isActive = true
        let trailing = charGraphView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        trailing.isActive = true
        charGraphView.topAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        charGraphView.heightAnchor.constraint(equalToConstant: UI.chartHeight + UI.yearArea).isActive = true

        bottomView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: charGraphView.bottomAnchor, constant: 40).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: backContentView.bottomAnchor).isActive = true
        yearButton.addTarget(self, action: #selector(updateChart), for: .touchUpInside)
        quaterButton.addTarget(self, action: #selector(updateChart), for: .touchUpInside)

        //info
        profitInfoView.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20).isActive = true
        profitInfoView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 18).isActive = true
        profitInfoView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profitInfoView.heightAnchor.constraint(equalToConstant: 14).isActive = true

        salesInfoView.trailingAnchor.constraint(equalTo: profitInfoView.leadingAnchor, constant: -8).isActive = true
        salesInfoView.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 18).isActive = true
        salesInfoView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        salesInfoView.heightAnchor.constraint(equalToConstant: 14).isActive = true

    }
    var bottomHeightConstraints: NSLayoutConstraint?

    @objc func updateChart(sender: UIButton) {
        [yearButton, quaterButton].forEach {
            $0.isSelected = false
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            $0.setTitleColor(AppColor.gray160.color, for: .normal)
        }

        sender.isSelected = true
        sender.setTitleColor(AppColor.darkgray62.color, for: .normal)
        sender.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        restChartView()
        var infoAlpha = 1.0
        if sender.tag == 99 {
            infoAlpha = 1.0
            preriodType = .year
            yearBar()
            indicatorLeading?.constant = 0
            indicatorWidth?.constant = yearButton.intrinsicContentSize.width
        } else {
            infoAlpha = 0.0
            preriodType = .quater
            quaterBar()
            indicatorLeading?.constant = quaterButton.frame.minX
            indicatorWidth?.constant = quaterButton.intrinsicContentSize.width
        }

        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.bottomView.layoutIfNeeded()
            
            self?.salesInfoView.alpha = CGFloat(infoAlpha)
        }

    }

    func configure(viewModel: HomeDetailViewModel) {
        self.viewModel = viewModel

        restChartView()
        if  preriodType == .quater {
            quaterBar()
        } else {
            yearBar()
        }

    }

    func restChartView() {
        for subView in charGraphView.subviews as [UIView] {
            subView.removeFromSuperview()
        }

        for subView in yearView.subviews as [UIView] {
            subView.removeFromSuperview()
        }
    }

    func yearBar() {

        let before: [CGFloat] = [1230, -10030, 1400 ]
        let after: [CGFloat] = [1590, 1002, 2900]
        let year: [String] = ["2018", "2019", "2020"]
        var total: [CGFloat] = []
        for index in 0..<before.count {
            total.append(before[index])
            total.append(after[index])
        }

        let yearView = YearBarView(frame: charGraphView.bounds)
        yearView.tag = 0
        charGraphView.addSubview(yearView)
        yearView.translatesAutoresizingMaskIntoConstraints = false
        yearView.fittingView(charGraphView)
        yearView.heightAnchor.constraint(equalTo: charGraphView.heightAnchor).isActive = true
        yearView.setNeedsLayout()
        yearView.layoutIfNeeded()
        yearView.total = total
        yearView.quater = year
        yearView.build()

    }

    func quaterBar() {

        let view = charGraphView.viewWithTag(1)
        view?.removeFromSuperview()

        let quater = QuaterBarView(frame: charGraphView.bounds)
        quater.tag = 1
        charGraphView.addSubview(quater)
        quater.translatesAutoresizingMaskIntoConstraints = false
        quater.fittingView(charGraphView)
        quater.heightAnchor.constraint(equalTo: charGraphView.heightAnchor).isActive = true
        quater.setNeedsLayout()
        quater.layoutIfNeeded()
        quater.total = [2395, 2431, 2304, 2337]
        quater.quater = ["20. 06", "20. 09", "20. 12", "21. 03"]
        quater.build()

    }

    func getPaddding() -> CGFloat {
        if preriodType == .quater {
            let content = -(35 * 4) - (40 * 3)
            return (self.frame.width - 40) + CGFloat(content)
        } else {
            let content = -(30 * 6) - 24 - 80

            return (self.frame.width) + CGFloat(content)
        }
    }
}

class BarChartBaseView: UIView, ViewType {
    enum PeriodType {
        case year
        case quater
    }
    var preriodType: PeriodType = .quater
    struct UI {
        static let totalHeight: CGFloat = 323
        static let topHeight: CGFloat =  90
        static let chartHeight: CGFloat =  90
        static let bottomHeight: CGFloat =  70
        static let yearArea: CGFloat = 17
        static let expandHeight: CGFloat = 40
    }
    var total: [CGFloat] = []
    var quater: [String] = []

    lazy var plusMax: CGFloat  = total .sorted(by: >).first ?? 0
    lazy var minusMax = total.sorted(by: <).first ?? 0
    lazy var maxValue = max(plusMax, abs(minusMax))
    lazy var minValue = min(plusMax, abs(minusMax))
    var ratio: CGFloat {
        get {
           return maxValue / minValue
        }
    }

    var standardView: UIView = {
        let standard = UIView()
        standard.backgroundColor = AppColor.gray225.color
        standard.translatesAutoresizingMaskIntoConstraints = false
        return standard
    }()

    lazy var yearView: UIView = {
        let bottom = UIView()
        return bottom
    }()

    var standardTopConstraints: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubview(standardView)
        addSubview(yearView)
        yearView.translatesAutoresizingMaskIntoConstraints = false

    }

    func setupConstraint() {
        standardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        standardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        standardView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        standardTopConstraints = standardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        standardTopConstraints?.isActive = true

        yearView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        yearView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        yearView.topAnchor.constraint(equalTo: bottomAnchor, constant: 16).isActive = true
        yearView.heightAnchor.constraint(equalToConstant: UI.yearArea).isActive = true

    }

    func generateBarLabel(priceValue: CGFloat, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(Int(priceValue))억"
        label.textColor = AppColor.darkgray82.color
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }

    func generateBarView(priceValue: Int) -> UIView {
        let barView = UIView()
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.layer.cornerRadius = 3
        barView.backgroundColor = AppColor.darkgray82.color
        return barView
    }

    func generateQuater(string: String) -> UILabel {
        let quaterLabel = UILabel()
        quaterLabel.text = string
        quaterLabel.translatesAutoresizingMaskIntoConstraints = false
        quaterLabel.textColor = AppColor.darkgray62.color
        quaterLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        quaterLabel.textAlignment = .center
        return quaterLabel
    }

}

class QuaterBarView: BarChartBaseView {

    func getPaddding() -> CGFloat {

        let content = -(35 * 4) - (40 * 3)
        return (self.frame.width - 40) + CGFloat(content)

    }

    func build() {
        var standardY: CGFloat = 0
        let padding = getPaddding()

        standardY = (UI.chartHeight + 40) / (ratio + 1.0)
        var startXais: CGFloat =  (padding / 2) + 20

        if total.filter({ $0 < 0.0 }).count == 0 {
            //다 양수일떄
            standardView.topAnchor.constraint(equalTo: topAnchor, constant: UI.chartHeight).isActive = true
            standardY = UI.chartHeight
        } else if plusMax > abs(minusMax) {
            standardView.topAnchor.constraint(equalTo: topAnchor, constant: UI.topHeight - standardY).isActive = true
            standardY = UI.topHeight - standardY
        } else {
            standardView.topAnchor.constraint(equalTo: topAnchor, constant: standardY).isActive = true
        }
        standardTopConstraints?.constant = standardY

        for (index, value) in total.enumerated() {
            let bar = generateBarView(priceValue: Int(value))
            addSubview(bar)

            let label = generateBarLabel(priceValue: value, textColor: AppColor.darkgray62.color)
            addSubview(label)
            label.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: -10).isActive = true
            label.centerXAnchor.constraint(equalTo: bar.centerXAnchor).isActive = true

            if value > 0 {
                let plusRatio = value / plusMax

                let barAxis =  abs((standardY * plusRatio))

                bar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                bar.widthAnchor.constraint(equalToConstant: 35).isActive = true
                bar.bottomAnchor.constraint(equalTo: standardView.topAnchor).isActive = true
                bar.heightAnchor.constraint(equalToConstant: barAxis).isActive = true
                bar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: startXais).isActive = true

            } else {

                let minusRatio = abs(value / (minusMax))
                //마이너스기준
                let minStandardY = (UI.chartHeight - standardY) * minusRatio

                bar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

                bar.widthAnchor.constraint(equalToConstant: 35).isActive = true
                bar.topAnchor.constraint(equalTo: standardView.bottomAnchor).isActive = true
                bar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: startXais).isActive = true
                bar.heightAnchor.constraint(equalToConstant: minStandardY).isActive = true

                //quater

            }
            let quaterLabel = generateQuater(string: quater[index])
             addSubview(quaterLabel)
             quaterLabel.bottomAnchor.constraint(equalTo: yearView.bottomAnchor).isActive = true
             quaterLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor).isActive = true
            startXais += 35 + 40
        }

    }

}

class YearBarView: BarChartBaseView {

    func getPaddding() -> CGFloat {

        let content = -(30 * 6) - 24 - 80 - 20

        return (self.frame.width) + CGFloat(content)

    }
    func build() {
        var standardY: CGFloat = 0
        let padding = getPaddding()
        var startXais: CGFloat =  (padding / 2) + 20
        standardY = (UI.chartHeight + 40) / (ratio + 1.0)
        if total.filter({ $0 < 0.0 }).count == 0 {
            //다 양수일떄
            standardY = UI.chartHeight
        } else if plusMax > abs(minusMax) {
            standardY = UI.topHeight - standardY
        }

        standardTopConstraints?.constant = standardY
        var yearIndex = 0

        for (index, value) in total.enumerated() {
            let bar = generateBarView(priceValue: Int(value))
            addSubview(bar)

            let label = generateBarLabel(priceValue: value, textColor: AppColor.darkgray62.color)
            addSubview(label)
            label.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: -10).isActive = true
            label.centerXAnchor.constraint(equalTo: bar.centerXAnchor).isActive = true

            if value > 0 {

                let plusRatio = value / plusMax

                let barAxis =  abs((standardY * plusRatio))

                bar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                bar.widthAnchor.constraint(equalToConstant: 30).isActive = true
                bar.bottomAnchor.constraint(equalTo: standardView.topAnchor).isActive = true
                bar.heightAnchor.constraint(equalToConstant: barAxis).isActive = true
                bar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: startXais).isActive = true

            } else {

                let minusRatio = abs(value / (minusMax))
                                   //마이너스기준
                let minStandardY = (UI.chartHeight - standardY) * minusRatio

                bar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

                bar.widthAnchor.constraint(equalToConstant: 30).isActive = true
                bar.topAnchor.constraint(equalTo: standardView.bottomAnchor).isActive = true
                bar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: startXais).isActive = true
                bar.heightAnchor.constraint(equalToConstant: minStandardY).isActive = true

                //quater

            }

            if index == 0 {
                startXais += 35 + 8
                bar.backgroundColor = AppColor.gray160.color
            } else   if  index % 2 != 0 {
                bar.backgroundColor = AppColor.darkgray82.color

                let quaterLabel = generateQuater(string: quater[yearIndex])
                 addSubview(quaterLabel)
                 quaterLabel.bottomAnchor.constraint(equalTo: yearView.bottomAnchor).isActive = true
                 quaterLabel.centerXAnchor.constraint(equalTo: bar.centerXAnchor, constant: -8 + -15).isActive = true
                yearIndex += 1
                startXais += 35 + 20
            } else {
                startXais += 35 + 8
                bar.backgroundColor = AppColor.gray160.color
            }
        }

    }

}
