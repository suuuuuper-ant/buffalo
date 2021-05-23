//
//  Company.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/25.
//

import Foundation

struct HomeCompany: Decodable {
    var data: HomeDataModel?

    private enum CodingKeys: String, CodingKey {
        case data

    }

    init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(HomeDataModel.self, forKey: .data)
    }
}

struct HomeDataModel: Decodable {
    var sections: [HomeSection] = []

    private enum CodingKeys: String, CodingKey {
        case sections

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sections = (try? container.decode([HomeSection].self, forKey: .sections)) ?? []
    }
}
struct News: Codable {
    let date: String
    let title: String
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

    private enum CodingKeys: String, CodingKey {
        case interestingCompany
        case tags
        case isFavorite
        case currentPrice
        case targetPrice
        case news
        case likeCount
        case opinionInfo

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
    }

}

protocol GroupSectionType {
    static var groupId: String { get }

}

struct GroupUpdateSecton: Decodable, GroupSectionType {
    static var groupId: String = "updatedCompany"
    var content: [Company] = []
}

struct HomeSection: Decodable {

    var groupId: String = ""
    var contents: [Any] = []

    init() {

    }
    enum CodingKeys: String, CodingKey {
        case groupId
        case contents
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        groupId = try container.decodeIfPresent(String.self, forKey: .groupId) ?? "ss"

        if groupId == "updatedCompany" {
            contents = try container.decodeIfPresent([Company].self, forKey: .contents) ?? []
        } else {
            contents = try container.decodeIfPresent([InterestedCompany].self, forKey: .contents) ?? []
        }

    }
}
