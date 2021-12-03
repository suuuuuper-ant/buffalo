//
//  Company.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/25.
//

import Foundation

struct HomeCompany: Decodable {
    var result: HomeDataModel?

    private enum CodingKeys: String, CodingKey {
        case result

    }

    init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decode(HomeDataModel.self, forKey: .result)
    }
}

struct HomeDataModel: Decodable {
    var groups: [HomeGroup] = []

    private enum CodingKeys: String, CodingKey {
        case groups = "groups"

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groups = (try? container.decode([HomeGroup].self, forKey: .groups)) ?? []
    }
}
struct News: Codable {
    let date: String
    let title: String
    var imageURL: String = "dummy"
}

struct OpinionInfo: Decodable {
    var opinion: StockType = .none
    var opinionDescription: String = ""
    var opinionCompany: String = ""
    var opinionDate: String = ""
    var report: String = ""

}

struct InterestedCompany: Decodable {
    var company: String = ""
    var companyThumbanil: String = ""
}

struct Company: Decodable {
    var interestingCompany: String = ""
    var tags: [String] = []
    var isFavorite: Bool = false
    var currentPrice: String = ""
    var targetPrice: String = ""
    var news: [News] = []
    var opinionInfo: OpinionInfo = OpinionInfo()
    var likeCount: Int = 0
    var compayThumbnail: String = ""

    private enum CodingKeys: String, CodingKey {
        case interestingCompany
        case tags
        case isFavorite
        case currentPrice
        case targetPrice
        case news
        case likeCount
        case opinionInfo
        case compayThumbnail

    }

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        interestingCompany = try values.decodeIfPresent(String.self, forKey: .interestingCompany) ?? ""
        tags = try values.decodeIfPresent([String].self, forKey: .tags) ?? []
        isFavorite = try values.decodeIfPresent(Bool.self, forKey: .isFavorite) ??  false
        currentPrice = try values.decodeIfPresent(String.self, forKey: .currentPrice) ?? ""
        targetPrice = try values.decodeIfPresent(String.self, forKey: .targetPrice) ?? ""
        news = try values.decodeIfPresent([News].self, forKey: .news) ?? []
        likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount) ?? 0
        opinionInfo = try values.decodeIfPresent(OpinionInfo.self, forKey: .opinionInfo) ?? OpinionInfo()
        compayThumbnail = try values.decodeIfPresent(String.self, forKey: .compayThumbnail) ?? ""
    }

}

protocol GroupSectionType {
    static var groupId: String { get }

}

struct HomeGroup: Decodable {

    var type: String = ""
    var action: String = ""
    var contents: [Any] = []

    init() {

    }
    enum CodingKeys: String, CodingKey {
        case type
        case contents
        case action
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? "ss"

        if type == "COMPANY" {
            contents = try container.decodeIfPresent([HomeUpdatedCompany].self, forKey: .contents) ?? []
        } else {
            contents = try container.decodeIfPresent([HomeInterestedCompany].self, forKey: .contents) ?? []
        }

    }
}

struct GroupUpdateSecton: Decodable, GroupSectionType {
    static var groupId: String = "updatedCompany"
    var content: [Company] = []
}

// home main card
struct HomeUpdatedCompany: Decodable {

    var company: HomeCompanyInfo
    var consensusList: [Consensus] = [Consensus()]
    var newsList: [HomeNews]

    enum CodingKeys: String, CodingKey {
        case company
        case consensusList
        case newsList
    }
}

struct HomeCompanyInfo: Decodable {
    var id: Int = 0
    var stockCode: String = ""
    var shortName: String = ""
    var likeCount: Int = 0
    var total: Int = 0
    var imageUrl: String = ""
    var category: String = ""
    var tags: [String] = []
    enum CodingKeys: String, CodingKey {
        case id
        case stockCode
        case shortName
        case likeCount
        case total
        case imageUrl
        case category

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
    }

    init(id: Int) {
        self.id = id
    }
}

struct Consensus: Decodable {

    var id: Int = -1
    var stockCode: String = "-1"
    var opinion: StockType = .notRated
    var price: String = "0"
    var createdAt: String = "0"
    var opinionCompany = "미정"

    enum CodingKeys: String, CodingKey {
        case id
        case stockCode
        case opinion
        case price
        case createdAt
        case opinionCompany

    }

    init() {}

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        stockCode = try values.decodeIfPresent(String.self, forKey: .stockCode) ?? ""
        opinion =  try values.decodeIfPresent(StockType.self, forKey: .opinion) ?? .none
        price = try values.decodeIfPresent(String.self, forKey: .price) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        opinionCompany = try values.decodeIfPresent(String.self, forKey: .opinionCompany) ?? ""
    }

}

struct HomeNews: Decodable {
    var id: Int
    var stockCode: String
    var title: String
    var link: String
    var description: String
    var createdAt: String

//    public init(from decoder: Decoder) throws {
//
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
//        stockCode = try values.decodeIfPresent(String.self, forKey: .stockCode) ?? ""
//        opinion =  try values.decodeIfPresent(StockType.self, forKey: .opinion) ?? .none
//        price = try values.decodeIfPresent(String.self, forKey: .price) ?? ""
//        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
//        opinionCompany = try values.decodeIfPresent(String.self, forKey: .opinionCompany) ?? ""
//    }

}

struct HomeInterestedCompany: Decodable {

    var company: HomeCompanyInfo?

    enum CodingKeys: String, CodingKey {
        case company

    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        company = try? values.decodeIfPresent(HomeCompanyInfo.self, forKey: .company)
    }

}
