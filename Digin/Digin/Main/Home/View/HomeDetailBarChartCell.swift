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
        static let totalHeight: CGFloat = 293
        static let topHeight: CGFloat =  42
        static let chartHeight: CGFloat =  totalHeight - topHeight - bottomHeight
        static let bottomHeight: CGFloat =  89
        static let expandHeight: CGFloat = 40
    }

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

    let charGraphView = BarChartView()

    lazy var infoView = UIView()
    lazy var bottomView: UIView = {
        let bottom = UIView()
        bottom.backgroundColor = .blue
        return bottom
    }()

    lazy var moreButton: UIButton = {
       let more = UIButton()
        more.setTitle("더보기", for: .normal)
        return more
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

        [infoView, charGraphView, bottomView].forEach {
            backContentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        bottomView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false

    }

    func setupConstraint() {

        backContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        backContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        backContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        backContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        infoView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: backContentView.topAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 42).isActive = true

        let leading = charGraphView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
        leading.priority = .defaultLow
        leading.isActive = true
       let trailing = charGraphView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor)
        trailing.priority = .defaultLow
        trailing.isActive = true
        charGraphView.centerXAnchor.constraint(equalTo: backContentView.centerXAnchor).isActive = true
        charGraphView.topAnchor.constraint(equalTo: infoView.bottomAnchor).isActive = true
        charGraphView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        charGraphView.heightAnchor.constraint(equalToConstant: UI.chartHeight).isActive = true

        bottomView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor).isActive = true
       // bottomView.topAnchor.constraint(equalTo: charGraphView.bottomAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: backContentView.bottomAnchor).isActive = true
        bottomHeightConstraints = bottomView.heightAnchor.constraint(equalToConstant: 89)
        bottomHeightConstraints?.isActive = true
        moreButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        moreButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -21).isActive = true
        moreButton.addTarget(self, action: #selector(updateChart), for: .touchUpInside)

    }
    var bottomHeightConstraints: NSLayoutConstraint?

    @objc func updateChart() {
        let profits: [CGFloat] = [1990.0, 52.0, 600.0]
        let profitDetail: [CGFloat] = [222.0, 502.0, 900.0]
        let years: [Int] = [2006, 2007, 2008]
//        charGraphView.graphs = TimeGraphData(profits: profits, profitDetail: profitDetail, years: years)

      //  charGraphView.update()
        isButtonClicked = true
        self.viewModel?.reeadMoreButtonTouched(IndexPath(item: 0, section: 0))

    }
    var isButtonClicked: Bool = false
    func configure(viewModel: HomeDetailViewModel) {
        self.viewModel = viewModel
     //   updateBarChart(type: 0)
        let profits: [CGFloat] = [1990.0, 52.0, 600.0]
        let profitDetail: [CGFloat] = [1590.0, 102.0, 300.0]
        let years: [Int] = [2006, 2007, 2008]
        charGraphView.graphs = TimeGraphData(profits: profits, profitDetail: profitDetail, years: years)

        if isButtonClicked == true {
            bottomHeightConstraints?.constant =  89 + UI.expandHeight
        }

      //  charGraphView.update()

    }

//    func updateBarChart(type: Int) {
//        if type == 1 {
//
//            let profits = [1990.0, 52.0, 600.0]
//
//            guard let max = profits.max() else { return }
//            for profit in profits {
//                let ratio = (profit / max)
//                let barView = BarView()
//              //  barView.stackView.backgroundColor = .black
//                barView.translatesAutoresizingMaskIntoConstraints = false
//               // barView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//                barView.heightAnchor.constraint(equalToConstant: 293).isActive = true
//                barchartStackView.addArrangedSubview(barView)
//                print(frame.height)
//
//                let spacing: CGFloat = 5
//                let labelHeight: CGFloat = 12
//                let  remainHeight: CGFloat = 1
//                barView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//                barView.barHeightConstraints?.constant = (frame.height - spacing - spacing - labelHeight - remainHeight) * CGFloat(ratio)
//
//            }
//
//        } else {
//            //vertical
//
//            // horizontal Stack
//            let barHorizontalView = UIStackView()
//            barHorizontalView.axis = .horizontal
//            barHorizontalView.alignment = .center
//            barHorizontalView.spacing = 40
//            let profits = [1990.0, 52.0, 600.0]
//            let profitDetail = [1590.0, 102.0, 300.0]
//            let years = [2006, 2007, 2008]
//
//            let profitsMax = profits.max() ?? 1.0
//            let profitsDetailMax = profitDetail.max() ?? 1.0
//
//            let max = max(profitsMax, profitsDetailMax)
//
//            for (index, value) in profits.enumerated() {
//                let ratio = (value / max)
//                let detail = profitDetail[index] / max
//
//                let profitBarView = BarView()
//                let profitDetailView = BarView()
//
//                profitBarView.heightAnchor.constraint(equalToConstant: 293 - 42 - 17 - 1 - 89).isActive = true
//                profitDetailView.heightAnchor.constraint(equalToConstant: 293 - 42 - 17 - 1 - 89).isActive = true
//                let stackView = UIStackView()
//                stackView.axis = .horizontal
//                stackView.spacing = 8
//                stackView.addArrangedSubview(profitDetailView)
//                stackView.addArrangedSubview(profitBarView)
//                barHorizontalView.addArrangedSubview(stackView)
//                profitBarView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//                profitDetailView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//                let spacing: CGFloat = 5
//                let labelHeight: CGFloat = 12
//                let  remainHeight: CGFloat = 1
//                profitBarView.barHeightConstraints?.constant = (frame.height - spacing - spacing - labelHeight - remainHeight) * CGFloat(ratio)
//                profitDetailView.barHeightConstraints?.constant = (frame.height - spacing - spacing - labelHeight - remainHeight) * CGFloat(detail)
//
//            }

            //separatedLine
//            let separatedLine = UIView()
//            separatedLine.backgroundColor = UIColor.init(named: "home_background")
//            separatedLine.translatesAutoresizingMaskIntoConstraints = false
//            separatedLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//            // years
//            let yearStack = UIStackView()
//            yearStack.axis = .horizontal
//            yearStack.translatesAutoresizingMaskIntoConstraints = false
//            yearStack.heightAnchor.constraint(equalToConstant: 17).isActive = true
//            for title in years {
//                let label = UILabel()
//                label.text = String(title)
//                label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//                yearStack.addArrangedSubview(label)
//            }
//            barchartStackView.addArrangedSubview(barHorizontalView)
//            barchartStackView.addArrangedSubview(separatedLine)
//            barchartStackView.addArrangedSubview(yearStack)
  //      }
//}

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
        addSubview(totalCharStackView)
        totalCharStackView.translatesAutoresizingMaskIntoConstraints = false

//        [chartHorizontalStackView, separatedLine, yearsStackView].forEach {
//            totalCharStackView.addSubview($0)
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        let chartAndLineStackView = UIStackView()
        chartAndLineStackView.spacing = 0
        chartAndLineStackView.axis = .vertical
        chartAndLineStackView.addArrangedSubview(chartHorizontalStackView)
        chartAndLineStackView.addArrangedSubview(separatedLine)

        totalCharStackView.addArrangedSubview(chartAndLineStackView)
        totalCharStackView.addArrangedSubview(yearsStackView)

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
