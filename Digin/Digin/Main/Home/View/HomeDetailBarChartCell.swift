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

    let charGraphView = UIView()

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

    var indicatorLeading: NSLayoutConstraint?
    var indicatorWidth: NSLayoutConstraint?

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

        let leading = charGraphView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
        //leading.priority = .defaultLow
        leading.isActive = true
        let trailing = charGraphView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor)
        //  trailing.priority = .defaultLow
        trailing.isActive = true
        //    charGraphView.centerXAnchor.constraint(equalTo: backContentView.centerXAnchor).isActive = true
        charGraphView.topAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        // charGraphView.bottomAnchor.constraint(equalTo: yearView.topAnchor).isActive = true
        charGraphView.heightAnchor.constraint(equalToConstant: UI.chartHeight).isActive = true

        yearView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 20).isActive = true
        yearView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -20).isActive = true
        yearView.topAnchor.constraint(equalTo: charGraphView.bottomAnchor, constant: 16).isActive = true
        yearView.heightAnchor.constraint(equalToConstant: UI.yearArea).isActive = true

        bottomView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor).isActive = true
        // bottomView.topAnchor.constraint(equalTo: charGraphView.bottomAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: yearView.bottomAnchor, constant: 40).isActive = true
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
    var standardView = UIView()
    var isButtonClicked: Bool = false
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

        standardView.removeFromSuperview()

    }

    func yearBar() {
        var standardY: CGFloat = 0
        let before: [CGFloat] = [1230, -230, 1400 ]
        let after: [CGFloat] = [1590, 1002, 2900]
        let year: [String] = ["2018", "2019", "2020"]
        if preriodType == .year {

            let padding = getPaddding()
            var startXais: CGFloat =  (padding / 2) + 10

            var total: [CGFloat] = []

            for index in 0..<before.count {
                total.append(before[index])
                total.append(after[index])
            }

            let plusMax = total .sorted(by: >).first ?? 0
            let minusMax = total.sorted(by: <).first ?? 0

            let max = max(plusMax, abs(minusMax))

            let min = min(plusMax, abs(minusMax))

            let ratio = max / min

            standardY = (UI.chartHeight + 40) / (ratio + 1.0)

            standardView = UIView()
            standardView.backgroundColor = AppColor.gray225.color

            charGraphView.addSubview(standardView)
            standardView.translatesAutoresizingMaskIntoConstraints = false
            standardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
            standardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
            standardView.heightAnchor.constraint(equalToConstant: 1).isActive = true

            if plusMax > abs(minusMax) {
                standardView.topAnchor.constraint(equalTo: charGraphView.topAnchor, constant: UI.topHeight - standardY).isActive = true
                standardY = UI.topHeight - standardY
            } else {
                standardView.topAnchor.constraint(equalTo: charGraphView.topAnchor, constant: standardY).isActive = true
            }

            var yearIndex = 0
            for (index, value) in total.enumerated() {
                let barView = UIView()
                //                let beforeValue = before[index]
                //                let afterValue = after[index]
                if value > 0 {
                    let plusRatio = value / plusMax

                    let barAxis =  abs((standardY * plusRatio))

                    charGraphView.addSubview(barView)
                    barView.translatesAutoresizingMaskIntoConstraints = false

                    barView.clipsToBounds = true
                    barView.layer.cornerRadius = 3
                    barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

                    barView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                    barView.bottomAnchor.constraint(equalTo: standardView.topAnchor).isActive = true
                    barView.heightAnchor.constraint(equalToConstant: barAxis).isActive = true
                    barView.leadingAnchor.constraint(equalTo: charGraphView.leadingAnchor, constant: startXais).isActive = true

                    let label = UILabel()
                    charGraphView.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.text = "\(Int(value))억"
                    label.textColor = AppColor.darkgray82.color
                    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                    label.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -10).isActive = true
                    label.centerXAnchor.constraint(equalTo: barView.centerXAnchor).isActive = true

                } else {

                    let minusRatio = abs(value / (minusMax))
                    //  let minStandardY = (standardY * minusRatio)
                    //마이너스기준
                    let minStandardY = (UI.chartHeight - standardY) * minusRatio

                    charGraphView.addSubview(barView)
                    barView.translatesAutoresizingMaskIntoConstraints = false
                    barView.layer.cornerRadius = 3
                    barView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

                    barView.backgroundColor = .darkGray
                    barView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                    barView.topAnchor.constraint(equalTo: standardView.bottomAnchor).isActive = true
                    barView.leadingAnchor.constraint(equalTo: charGraphView.leadingAnchor, constant: startXais).isActive = true
                    barView.heightAnchor.constraint(equalToConstant: minStandardY).isActive = true

                    // startXais += 35 + 8

                    let label = UILabel()
                    charGraphView.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.textColor = AppColor.darkgray82.color
                    label.text = "\(Int(value))억"
                    label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                    label.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -10).isActive = true
                    label.centerXAnchor.constraint(equalTo: barView.centerXAnchor).isActive = true
                }
                if index == 0 {
                    startXais += 35 + 8
                    barView.backgroundColor = AppColor.gray160.color
                } else   if  index % 2 != 0 {
                    barView.backgroundColor = AppColor.darkgray82.color

                    let quaterLabel = UILabel()
                    quaterLabel.text = year[yearIndex]
                    charGraphView.addSubview(quaterLabel)
                    quaterLabel.translatesAutoresizingMaskIntoConstraints = false
                    quaterLabel.textColor = AppColor.darkgray62.color
                    quaterLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
                    quaterLabel.textAlignment = .center
                    quaterLabel.bottomAnchor.constraint(equalTo: yearView.bottomAnchor).isActive = true
                    quaterLabel.centerXAnchor.constraint(equalTo: barView.leadingAnchor, constant: -4).isActive = true
                    yearIndex += 1
                    startXais += 35 + 20
                } else {
                    startXais += 35 + 8
                    barView.backgroundColor = AppColor.gray160.color
                }

            }

            // startXais -= 2

        }
    }

    func quaterBar() {
        var standardY: CGFloat = 0
        let profits: [CGFloat] = [2395, 2431, 2304, 2337]
        let quater: [String] = ["20. 06", "20. 09", "20. 12", "21. 03"]

        // 음수가 더 클 때
        let plusMax = profits.sorted(by: >).first ?? 0
        let minusMax = profits.sorted(by: <).first ?? 0

        let max = max(plusMax, abs(minusMax))

        let min = min(plusMax, abs(minusMax))

        let ratio = max / min

        standardY = (UI.chartHeight + 40) / (ratio + 1.0)

        let yAxis = UI.chartHeight / standardY

        standardView = UIView()
        standardView.backgroundColor = AppColor.gray225.color

        charGraphView.addSubview(standardView)
        standardView.translatesAutoresizingMaskIntoConstraints = false
        standardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        standardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        standardView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        if profits.filter { $0 < 0.0 }.count == 0 {
            //다 양수일떄
            standardView.topAnchor.constraint(equalTo: charGraphView.topAnchor, constant: UI.chartHeight).isActive = true
            standardY = UI.chartHeight
        } else if plusMax > abs(minusMax) {
            standardView.topAnchor.constraint(equalTo: charGraphView.topAnchor, constant: UI.topHeight - standardY).isActive = true
            standardY = UI.topHeight - standardY
        } else {
            standardView.topAnchor.constraint(equalTo: charGraphView.topAnchor, constant: standardY).isActive = true
        }

        let padding = getPaddding()
        var startXais: CGFloat =  (padding / 2) + 20

        //            var firstBarLeadingConstraints: NSLayoutConstraint?
        //            var nextLabel: UILabel?
        for (index, value) in profits.enumerated() {

            if value > 0 {
                let plusRatio = value / plusMax

                let barAxis =  abs((standardY * plusRatio))

                let barView = UIView()
                charGraphView.addSubview(barView)
                barView.translatesAutoresizingMaskIntoConstraints = false

                barView.clipsToBounds = true
                barView.layer.cornerRadius = 3
                barView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

                barView.backgroundColor = .darkGray
                barView.widthAnchor.constraint(equalToConstant: 35).isActive = true
                barView.bottomAnchor.constraint(equalTo: standardView.topAnchor).isActive = true
                barView.heightAnchor.constraint(equalToConstant: barAxis).isActive = true
                barView.leadingAnchor.constraint(equalTo: charGraphView.leadingAnchor, constant: startXais).isActive = true

                // label
                let label = UILabel()
                charGraphView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "\( Int(value))억"
                label.textColor = AppColor.darkgray82.color
                label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                label.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -10).isActive = true
                label.centerXAnchor.constraint(equalTo: barView.centerXAnchor).isActive = true
                startXais += 35 + 40

                let quaterLabel = UILabel()
                quaterLabel.text = quater[index]
                charGraphView.addSubview(quaterLabel)
                quaterLabel.translatesAutoresizingMaskIntoConstraints = false
                quaterLabel.textColor = AppColor.darkgray62.color
                quaterLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
                quaterLabel.textAlignment = .center
                quaterLabel.bottomAnchor.constraint(equalTo: yearView.bottomAnchor).isActive = true
                quaterLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor).isActive = true
            } else {

                let minusRatio = abs(value / (minusMax))
                //  let minStandardY = (standardY * minusRatio)
                //마이너스기준
                let minStandardY = (UI.chartHeight - standardY) * minusRatio

                let yAxis =  minStandardY + standardY

                let barView = UIView()
                charGraphView.addSubview(barView)
                barView.translatesAutoresizingMaskIntoConstraints = false
                barView.layer.cornerRadius = 3
                barView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

                barView.backgroundColor = .darkGray
                barView.widthAnchor.constraint(equalToConstant: 35).isActive = true
                barView.topAnchor.constraint(equalTo: standardView.bottomAnchor).isActive = true
                barView.leadingAnchor.constraint(equalTo: charGraphView.leadingAnchor, constant: startXais).isActive = true
                barView.heightAnchor.constraint(equalToConstant: minStandardY).isActive = true

                startXais += 35 + 40

                let label = UILabel()
                charGraphView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textColor = AppColor.darkgray82.color

                label.text = "\(Int(value))억"
                label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                label.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -10).isActive = true
                label.centerXAnchor.constraint(equalTo: barView.centerXAnchor).isActive = true

                //quater
                let quaterLabel = UILabel()
                quaterLabel.text = quater[index]
                charGraphView.addSubview(quaterLabel)
                quaterLabel.translatesAutoresizingMaskIntoConstraints = false
                quaterLabel.textColor = AppColor.darkgray62.color
                quaterLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
                quaterLabel.textAlignment = .center

                quaterLabel.bottomAnchor.constraint(equalTo: yearView.bottomAnchor).isActive = true
                quaterLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor).isActive = true
            }

        }

    }

    func getPaddding() -> CGFloat {
        if preriodType == .quater {
            let content = -(35 * 4) - (40 * 3)
            return (self.frame.width - 40) + CGFloat(content)
        } else {
            let content = -(30 * 6) - 24 - 80

            return (self.frame.width) + CGFloat(content)

        }
        return 0

    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

    }
}

//let profits = [1990.0, 52.0, 600.0]
//let profitDetail = [1590.0, 102.0, 300.0]
//let years = [2006, 2007, 2008]

struct TimeGraphData {
    var profits: [CGFloat]
    var profitDetail: [CGFloat]
    var years: [Int]

    init (profits: [CGFloat] = [], profitDetail: [CGFloat] = [], years: [Int] = []) {
        self.profits = profits
        self.profitDetail = profitDetail
        self.years = years

    }
}

class BarChartView: UIView, ViewType {

    var graphs = TimeGraphData() {
        didSet {
            setNeedsLayout()
        }
    }

    lazy var totalCharStackView: UIStackView = {
        let totalCharStackView = UIStackView()
        totalCharStackView.axis = .vertical
        totalCharStackView.spacing = 16
        return totalCharStackView
    }()

    lazy var chartHorizontalStackView: UIStackView = {
        let chart = UIStackView()
        chart.axis = .horizontal
        chart.spacing = 40
        return chart
    }()

    lazy var separatedLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(named: "home_background")
        return line
    }()

    lazy var yearsStackView: UIStackView = {
        let years = UIStackView()
        years.axis = .horizontal
        years.spacing = 40
        years.alignment = .center
        years.distribution = .equalCentering
        return years
    }()

    func setupUI() {
        //        addSubview(totalCharStackView)
        //        totalCharStackView.translatesAutoresizingMaskIntoConstraints = false

        //        [chartHorizontalStackView, separatedLine, yearsStackView].forEach {
        //            totalCharStackView.addSubview($0)
        //            $0.translatesAutoresizingMaskIntoConstraints = false
        //        }
        //        let chartAndLineStackView = UIStackView()
        //        chartAndLineStackView.spacing = 0
        //        chartAndLineStackView.axis = .vertical
        //        chartAndLineStackView.addArrangedSubview(chartHorizontalStackView)
        //        chartAndLineStackView.addArrangedSubview(separatedLine)
        //
        //        totalCharStackView.addArrangedSubview(chartAndLineStackView)
        //        totalCharStackView.addArrangedSubview(yearsStackView)

    }

    func update() {

        chartHorizontalStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }

        //        let chartAndLineStackView = UIStackView()
        //        chartAndLineStackView.spacing = 0
        //        chartAndLineStackView.axis = .vertical
        //        chartAndLineStackView.addArrangedSubview(chartHorizontalStackView)
        //        chartAndLineStackView.addArrangedSubview(separatedLine)

        //        totalCharStackView.addArrangedSubview(chartAndLineStackView)
        //        totalCharStackView.addArrangedSubview(yearsStackView)

        let profitsMax = graphs.profits.max() ?? 1.0
        let profitsDetailMax = graphs.profitDetail.max() ?? 1.0

        let max = max(profitsMax, profitsDetailMax)

        for (index, value) in graphs.profits.enumerated() {
            let ratio = (value / max)
            let detail = graphs.profitDetail[index] / max

            let profitBarView = BarView()
            let profitDetailView = BarView()

            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.addArrangedSubview(profitDetailView)
            stackView.addArrangedSubview(profitBarView)
            chartHorizontalStackView.addArrangedSubview(stackView)

            let spacing: CGFloat = 5
            let labelHeight: CGFloat = 12
            let  remainHeight: CGFloat = 1
            profitBarView.barHeightConstraints?.constant = (self.frame.height - spacing - spacing - labelHeight - remainHeight - 17 - 1 - 40) * CGFloat(ratio)
            profitDetailView.barHeightConstraints?.constant = (self.frame.height - spacing - spacing - labelHeight - remainHeight - 17 - 1 - 40) * CGFloat(detail)

        }

        yearsStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }

        for title in graphs.years {
            let label = UILabel()
            label.text = String(title)
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            yearsStackView.addArrangedSubview(label)
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.update()
    }

    func setupConstraint() {
        separatedLine.translatesAutoresizingMaskIntoConstraints = false
        separatedLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        yearsStackView.translatesAutoresizingMaskIntoConstraints = false
        yearsStackView.heightAnchor.constraint(equalToConstant: 17).isActive = true

        let leading = totalCharStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        // leading.priority = .defaultLow
        leading.isActive = true
        let trailing = totalCharStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        //   trailing.priority = .defaultLow
        trailing.isActive = true
        totalCharStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalCharStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        totalCharStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        // yearsStackView.heightAnchor.constraint(equalToConstant: 17).isActive = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class BarView: UIView, ViewType {
    var maxValue: CGFloat = 0
    var profitValue: CGFloat = 0
    let operatinProfitBarView: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.init(named: "gray_160")
        return bar
    }()

    let operatinProfitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "1,993조"
        return label
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [operatinProfitLabel, operatinProfitLabel].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    var barHeightConstraints: NSLayoutConstraint?
    func setupConstraint() {
        stackView.fittingView(self)
        let view = UIView()
        // view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(operatinProfitLabel)
        stackView.addArrangedSubview(operatinProfitBarView)
        stackView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        operatinProfitLabel.adjustsFontSizeToFitWidth = true
        operatinProfitLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        barHeightConstraints = operatinProfitBarView.heightAnchor.constraint(equalToConstant: 50)
        barHeightConstraints?.isActive = true

    }

    deinit {
        print("deinit")
    }

}
