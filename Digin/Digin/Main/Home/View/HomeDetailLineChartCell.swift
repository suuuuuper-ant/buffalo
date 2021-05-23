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
        price.text = "34,500원"
        price.font = UIFont.boldSystemFont(ofSize: 30)
        return price
    }()

    lazy var percentLabel: UILabel = {
        let percent = UILabel()
        percent.text = "-3% (-100원)"
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
        period.spacing = 52
        period.distribution = .equalCentering
        return period
    }()
    lazy var chartView: GraphView = GraphView()

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

        for (index, button) in PeriodGenerator(3).generateTagLabels().enumerated() {
            button.setTitle("오늘", for: .normal)
            button.tag = index
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

    override func layoutSubviews() {
        super.layoutSubviews()

        // backContentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }

    @objc func selectedPeriodButton(sender: UIButton) {
        chartView.periodType = GraphView.Period.init(rawValue: sender.tag) ?? .today

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
                return ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                        [1000, 1600, 3500, 4600, 2900, 2300, 3200, 5000, 4500, 10000, 500, 4500] )
            default:
                return([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30],
                       [300, 1500, 1500, 600, 2900, 2300, 3200, 3200, 230, 500, 400, 1500, 1000, 500, 4500, 320, 3100, 230, 800, 400, 1500, 300, 400, 500, 200, 300, 250, 290, 390, 400])
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
    weak var shapeLayer: CAShapeLayer?
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white

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
        let width = frame.width
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
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = periodType.periodArray.1.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yaxis = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - yaxis
        }

        let graphPath = UIBezierPath()

        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(week[0])))

        for index in 0..<periodType.periodArray.1.count {
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

            if index == 0 {
                button.backgroundColor = UIColor.init(named: "tag_color")
                button.titleLabel?.textColor = .white
            } else {
                button.backgroundColor = UIColor.white
                button.layer.borderWidth = 1
            }

            buttons.append(button)
        }
        return buttons
    }

}
