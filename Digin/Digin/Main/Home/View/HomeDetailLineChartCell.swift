//
//  HomeDetailLineChartCell.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/04.
//

import UIKit

class HomeDetailLineChartCell: UITableViewCell, ViewType {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraint()
    }

    let backContentView = UIView()

    lazy var currentPriceLabel: UILabel = {
        let price = UILabel()
        price.text = "827,000원"
        price.font = UIFont.boldSystemFont(ofSize: 30)
        return price
    }()

    lazy var percentLabel: UILabel = {
        let percent = UILabel()
        percent.text = "-3% (-24810원)"
        percent.font = UIFont.boldSystemFont(ofSize: 16)
        return percent
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var periodStackView: UIStackView =  {
        let period = UIStackView()
        period.axis = .horizontal
        period.alignment = .center
        period.spacing = 40
        period.distribution = .equalCentering
        return period
    }()
    lazy var chartView: GraphView = GraphView(frame: .zero)

    var stockType: StockType = .none

    func setupUI() {

        contentView.backgroundColor = UIColor.init(named: "home_background")
        self.backgroundColor = UIColor.init(named: "home_background")
        contentView.addSubview(backContentView)
        backContentView.translatesAutoresizingMaskIntoConstraints = false

        backContentView.backgroundColor = .white
        backContentView.layer.cornerRadius = 15
        backContentView.layer.masksToBounds = true

        [currentPriceLabel, percentLabel, chartView, periodStackView].forEach {
            backContentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let period = ["오늘", "1주", "1달", "3달", "6달"]

        for (index, button) in PeriodGenerator(5).generateTagLabels().enumerated() {
            button.setTitle( period[index] ?? "", for: .normal)
            button.tag = index
           // button.backgroundColor = stockType.colorForType()
            button.addTarget(self, action: #selector(selectedPeriodButton), for: .touchUpInside)
            periodStackView.addArrangedSubview(button)
        }
    }

    func setupConstraint() {

        backContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        backContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        backContentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        backContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        currentPriceLabel.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 20).isActive = true
        currentPriceLabel.topAnchor.constraint(equalTo: backContentView.topAnchor, constant: 30).isActive = true
        currentPriceLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -10).isActive = true

        percentLabel.centerYAnchor.constraint(equalTo: currentPriceLabel.centerYAnchor).isActive = true
        let trailing = percentLabel.trailingAnchor.constraint(greaterThanOrEqualTo: backContentView.trailingAnchor, constant: -10)
        trailing.priority = .defaultLow
        trailing.isActive = true
        chartView.leadingAnchor.constraint(equalTo: backContentView.leadingAnchor, constant: 20).isActive = true
        chartView.trailingAnchor.constraint(equalTo: backContentView.trailingAnchor, constant: -20).isActive = true
        chartView.topAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 37).isActive = true

        chartView.heightAnchor.constraint(equalToConstant: 117).isActive = true

        let periodLeading = periodStackView.leadingAnchor.constraint(greaterThanOrEqualTo: backContentView.leadingAnchor, constant: 20)
        periodLeading.priority = .defaultLow
        periodLeading.isActive = true
        let periodTrailing = periodStackView.trailingAnchor.constraint(greaterThanOrEqualTo: backContentView.trailingAnchor, constant: -20)
        periodTrailing.priority = .defaultLow
        periodTrailing.isActive = true
        periodStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        periodStackView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 24).isActive = true
        periodStackView.bottomAnchor.constraint(equalTo: backContentView.bottomAnchor, constant: -37).isActive = true
    }

    @objc func selectedPeriodButton(sender: UIButton) {

        periodStackView.subviews.forEach { view in
            let button =  view as? UIButton
            button?.isSelected = false
            button?.backgroundColor = .white
            button?.setTitleColor(AppColor.gray160.color, for: .normal)

        }
        sender.isSelected = true
        sender.backgroundColor = stockType.colorForType()
        sender.layer.borderColor = UIColor.white.cgColor
        sender.setTitleColor(.white, for: .normal)
        chartView.periodType = GraphView.Period.init(rawValue: sender.tag) ?? .today

    }

    func configure(_ stockType: StockType) {
        self.stockType =  stockType
        periodStackView.subviews.forEach { view in
            let button = view as? UIButton
            if button?.isSelected ?? false {
                button?.backgroundColor = stockType.colorForType()
                button?.layer.borderColor = UIColor.white.cgColor
                button?.setTitleColor(.white, for: .normal)
            }
        }
        percentLabel.textColor = stockType.colorForType()

    }

}

class GraphView: UIView {

    enum Period: Int {

        case today = 0
        case week = 1
        case month =  2
        case threeMonth = 3
        case sixMonth = 4

        var periodArray: ([Int], [Int]) {
            switch self {
            case  .today:
                return ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
                        [35800, 48000, 58200, 65000, 65000, 69000, 65000, 65000, 67000, 75000, 74000, 69000, 72000] )
            default:
                return([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
                       //마지막은 목표가
                       [59000, 60000, 63000, 62500, 64000, 65000, 65500, 65000, 68000, 68200, 67000, 69000, 70000, 75000, 79000, 69820, 65800, 100000])
            }
        }

    }

    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 0
        static let bottomBorder: CGFloat = 0
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    let week =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let price = [0, 2000]
    var periodType: Period = .today {
        didSet {
            updateChartLine()

        }
    }

    var currentPriceLine: UIView = {
        let line = UIView()
        line.backgroundColor = AppColor.darkgray82.color
        return line
    }()

    weak var shapeLayer: CAShapeLayer?
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white

    var lineYConstraints: NSLayoutConstraint?
    var lineWidthConstraints: NSLayoutConstraint?

    var goalLabel: UILabel = {
       let goal = UILabel()
        goal.textColor = AppColor.darkgray82.color
        goal.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        goal.numberOfLines = 2
        return goal
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(currentPriceLine)
        currentPriceLine.translatesAutoresizingMaskIntoConstraints = false
        currentPriceLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        currentPriceLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineWidthConstraints = currentPriceLine.widthAnchor.constraint(equalToConstant: 0)
        lineWidthConstraints?.isActive = true
        lineYConstraints =  currentPriceLine.topAnchor.constraint(equalTo: topAnchor)
        lineYConstraints?.isActive = true

        addSubview(goalLabel)
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        goalLabel.leadingAnchor.constraint(equalTo: currentPriceLine.trailingAnchor, constant: 5.5).isActive = true
        goalLabel.centerYAnchor.constraint(equalTo: currentPriceLine.centerYAnchor).isActive = true

        goalLabel.alpha = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]

        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // 4
        let colorLocations: [CGFloat] = [0.0, 0.0]

        // 5
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!

        // 6
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])

        self.layer.backgroundColor = UIColor.white.cgColor

        updateChartLine()

    }
    func updateChartLine() {
        let width = frame.width - 40
        let height = frame.height
        self.shapeLayer?.removeFromSuperlayer()
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacing = graphWidth / CGFloat(self.periodType.periodArray.0.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }

        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder + 100
        let maxValue = periodType.periodArray.1.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yaxis = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - yaxis
        }

        let graphPath = UIBezierPath()

        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(periodType.periodArray.1[0])))

        for index in 0..<periodType.periodArray.1.count - 1 {
            let nextPoint = CGPoint(x: columnXPoint(index), y: columnYPoint(periodType.periodArray.1[index]))
            graphPath.addLine(to: nextPoint)
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        shapeLayer.path = graphPath.cgPath

        self.layer.addSublayer(shapeLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 2
        shapeLayer.add(animation, forKey: "MyAnimation")

        self.shapeLayer = shapeLayer

        //임시로 넣어놓음
        let goalPrice = periodType.periodArray.1.last
       let goalY = columnYPoint(goalPrice!)
        lineYConstraints?.constant = goalY
        lineWidthConstraints?.constant = width - 40

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        guard  numberFormatter.string(from: NSNumber(integerLiteral: periodType.periodArray.1.last ?? 0)) != nil else { return }
        let price = 824000
        goalLabel.text = "목표가\n\(price)원"

        UIView.animate(withDuration: 2) {
            self.layoutIfNeeded()

        } completion: {[weak self] _ in
            UIView.animate(withDuration: 0.5) {
                self?.goalLabel.alpha = 1
            }
        }

    }

}

class PeriodGenerator {

    let count: Int
    let textArray: [String]?
    init(_ count: Int, textArray: [String]? = nil) {
        self.count = count
        self.textArray = textArray
    }

    func generateTagLabels() -> [UIButton] {

        var buttons: [UIButton] = []
        for index in (0..<count) {

            let button = UIButton()

            button.makeRounded(cornerRadius: 13)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            button.layer.borderColor = UIColor.white.cgColor
            if index == 0 {
                button.isSelected = true
//                button.backgroundColor = UIColor.init(named: "tag_color")
                button.titleLabel?.textColor = AppColor.gray160.color
            } else {
                button.backgroundColor = UIColor.white
                button.titleLabel?.textColor = AppColor.gray160.color
                button.setTitleColor(AppColor.gray160.color, for: .normal)
                button.layer.borderWidth = 1
            }

            buttons.append(button)
        }
        return buttons
    }

}
