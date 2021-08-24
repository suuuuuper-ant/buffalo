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
}

struct HomeDetailResult: Decodable {
    var status: String
    var result: HomeDetail
}
