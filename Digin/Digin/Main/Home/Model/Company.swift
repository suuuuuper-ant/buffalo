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

struct Company: Decodable {
    let interestingCompany: String
    let tags: [String]
    let isFavorite: Bool
    let currentPrice: String
    let targetPrice: String

    private enum CodingKeys: String, CodingKey {
        case interestingCompany
        case tags
        case isFavorite
        case currentPrice
        case targetPrice

        }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        interestingCompany = try values.decodeIfPresent(String.self, forKey: .interestingCompany) ?? ""
        tags = try values.decodeIfPresent([String].self, forKey: .tags) ?? []
        isFavorite = try values.decodeIfPresent(Bool.self, forKey: .isFavorite) ??  false
        currentPrice = try values.decodeIfPresent(String.self, forKey: .currentPrice) ?? ""
        targetPrice = try values.decodeIfPresent(String.self, forKey: .targetPrice) ?? ""
    }

}
