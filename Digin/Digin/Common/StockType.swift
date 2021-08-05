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
            return "적극 사세요."
        case .sell:
            return "적극 파세요."
        case .marketPerform:
            return "가니님의 의견이 필요할 때에요."
        default:
            return "아직 정의 되지않은 마크"
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
