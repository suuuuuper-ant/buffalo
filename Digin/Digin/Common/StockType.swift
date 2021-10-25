//
//  StockType.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/23.
//

import UIKit

enum StockType: String, CaseIterableDefaultsLast, Codable {

    case buy = "Buy"
    case sell = "Sell"
    case marketPerform = "Marketperform"
    case neutral = "neutral"
    case notRated = "Not Rated"
    case hold = "Hold"
    case none = ""

    func colorForType() -> UIColor {
        switch self {
        case .buy:
            return  AppColor.stockRed.color
        case .sell:
            return AppColor.stockSell.color
        case .marketPerform:
            return AppColor.stockMarketperform.color
        case .neutral:
            return AppColor.stockNeutral.color
        case .notRated:
            return AppColor.stockNeutral.color
        case .hold:
            return AppColor.stockHold.color
        default:
            return UIColor.white
        }
    }

    func decription() -> String {

        switch self {
        case .buy:
            return "구매해도 좋다는 의견이 많아요"
        case .sell:
            return "팔아도 좋다는 의견이 많아요"
        case .marketPerform:
            return "좀 더 지켜보자는 의견이에요"
        case .neutral:
            return "중립적인 의견이 많아요"
        default:
            return "평가하지않은 의견이 많아요"
        }
    }

    enum IconType: String {
        case normal = ""
        case white = "_white"

    }
    func stockTypeIconImage(_ iconType: IconType = .normal) -> UIImage? {
        let typeString = "\(iconType)"
        switch self {
        case .buy:
            return UIImage(named: "icon_home_buy\(typeString)")
        case .sell:
            return UIImage(named: "icon_home_sell\(typeString)")
        case .hold:
            return UIImage(named: "icon_home_hold\(typeString))")
        case .neutral:
            return UIImage(named: "icon_home_normal\(typeString)")
        case .marketPerform:
            return UIImage(named: "icon_home_marketplatform\(typeString)")
        default:
            return UIImage(named: "icon_home_normal\(typeString)")
        }

    }

    func stockTypeHeadString() -> (String, String) {
        switch self {
        case .buy:
            return ("구매해도", "좋다는 의견이에요")
        case .sell:
            return ("팔아도", "좋다는 의견이에요")
        case .hold:
            return ("평가하지 않은", "의견이에요")
        case .neutral:
            return  ("중립적인", "의견이에요")
        case .marketPerform:
            return ("좀 더 지켜보자는", "의견이에요")
        default:
            return ("평가하지 않은", "의견이에요")
        }
    }
}

protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable
where RawValue: Decodable, AllCases: BidirectionalCollection { }

extension CaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}
