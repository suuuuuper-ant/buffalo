//
//  Company.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/25.
//

import Foundation

struct HomeCompany: Decodable {
    let data: [Company]

    private enum CodingKeys: String, CodingKey {
            case data
        }

    init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.data = try container.decode([Company].self, forKey: .data)
       }
}

struct News: Codable {
    let date: String
    let title: String
}

struct OpinionInfo: Codable {
    var opinion: String = ""
    var opinionDescription: String = ""
    var opinionCompany: String = ""
    var opinionDate: String = ""
    var report: String = ""

}

struct Company: Decodable {
    let interestingCompany: String
    let tags: [String]
    let isFavorite: Bool
    let currentPrice: String
    let targetPrice: String
    let news: [News]
    let opinionInfo: OpinionInfo
    let likeCount: Int
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
