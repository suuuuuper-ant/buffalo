//
//  HomeDetail.swift
//  Digin
//
//  Created by jinho jeong on 2021/08/21.
//

import UIKit

struct HomeDetailCompanyInfo: Decodable {
    var id: Int = 0
    var stockCode: String = ""
    var shortName: String = ""
    var likeCount: Int = 0
    var total: Int = 0
    var imageUrl: String = ""
    var category: String = ""
    var searchCount: Int = 0
    var tags: [String] = []
    enum CodingKeys: String, CodingKey {
        case id
        case stockCode
        case shortName
        case likeCount
        case total
        case imageUrl
        case category
        case searchCount

    }

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        stockCode = try values.decodeIfPresent(String.self, forKey: .stockCode) ?? ""
        shortName = try values.decodeIfPresent(String.self, forKey: .shortName) ?? ""
        likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount) ?? 0
        total = try values.decodeIfPresent(Int.self, forKey: .total) ?? 0
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
        category = try values.decodeIfPresent(String.self, forKey: .category) ?? ""
        searchCount = try values.decodeIfPresent(Int.self, forKey: .searchCount) ?? 0
    }

    init() {}
}

struct NewsDetail: Decodable {

    var id: Int = 0
    var stockCode: String = ""
    var title: String = ""
    var link: String = ""
    var description: String = ""
    var createdAt: String = ""
    var imageUrl: String = ""
}

struct Stack: Decodable {

    var id: Int = 0
    var stockCode: String = ""
    var open: Int = 0
    var close: Int = 0
    var high: Int = 0
    var low: Int = 0
    var date: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
}

struct Annual: Decodable {

    var id: Int = 0
    var stockCode: String = ""
    var date: String = ""
    var sales: String = ""
    var profit: String = ""
    var isExpect: Bool = false
}

struct Quarter: Decodable {

    var id: Int = 0
    var stockCode: String = ""
    var date: String = ""
    var sales: String = ""
    var profit: String = ""
    var isExpect: Bool = false

}

struct HomeDetail: Decodable {

    enum Period: Int {

        //case today = 0
        case week = 1
        case month =  2
        case threeMonth = 3
        case sixMonth = 4

//        var periodArray: ([Int], [Int]) {
//            switch self {
//            case  .today:
//                return ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
//                        [35800, 48000, 58200, 65000, 65000, 69000, 65000, 65000, 67000, 75000, 74000, 69000, 72000] )
//
//            case .week:
//
//
//            default:
//                return([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
//                       //마지막은 목표가
//                       [59000, 60000, 63000, 62500, 64000, 65000, 65500, 65000, 68000, 68200, 67000, 69000, 70000, 75000, 79000, 69820, 65800, 100000])
//            }
//        }

    }

    var company: HomeDetailCompanyInfo  = HomeDetailCompanyInfo()
    var consensusList: [Consensus] = []
    var newsList: [NewsDetail] = []
    var stacks: [Stack] = []
    var annuals: [Annual] = []
    var quarters: [Quarter] = []

    init() {}

    func getAnnualSales() -> [CGFloat] {

        let annualsSales = annuals.map { annual -> CGFloat in
            let str = annual.sales.replacingOccurrences(of: ",", with: "")
            return CGFloat((str as NSString).floatValue)
        }

        if annualsSales.count > 3 {
            return annualsSales.suffix(3)
        }
        return annualsSales
    }

    func getAnnualProfits() -> [CGFloat] {

        let annualsProfits = annuals.map { annual -> CGFloat in
            let str = annual.profit.replacingOccurrences(of: ",", with: "")
            return CGFloat((str as NSString).floatValue)
        }

        if annualsProfits.count > 3 {
            return annualsProfits.suffix(3)
        }
        return annualsProfits
    }

    func getAnumalDates() -> [String] {

        let dates = annuals.map { annual in
            annual.date
        }

        if dates.count > 3 {
            return dates.suffix(3)
        }
        return dates
    }

    func getQuatersDate() -> [String] {

      return quarters.map { quarter in
            quarter.date
        }
    }

    func getQuarterProfits() -> [CGFloat] {

        let quaterProfits = quarters.map { quarter -> CGFloat in
           let str = quarter.profit.replacingOccurrences(of: ",", with: "")
            return CGFloat((str as NSString).floatValue)
        }
        if quaterProfits.count > 4 {
            return quaterProfits.suffix(4)
        }
        return quaterProfits
    }

    func getStacksOnWeek(period: Period) -> ([Int], [Int]) {

        switch period {
        case .week:
            let values = stacks.map { stack in
                stack.close / 1000
            }
            let day = stacks.enumerated().map { stack in
                stack.offset + 1
            }
            //20000 [8000, 13500, 11500, 12500, 0]
            // [12000,6500,8500,7500,20000]
            return ([1, 2, 3, 4, 5], [12000, 6500, 8500, 7500, 20000])
        default:
            let values = stacks.map { stack in
                stack.close
            }
            let day = stacks.enumerated().map { stack in
                stack.offset + 1
            }
            return (day, values)
        }

    }

}

struct HomeDetailResult: Decodable {
    var status: String
    var result: HomeDetail
}
