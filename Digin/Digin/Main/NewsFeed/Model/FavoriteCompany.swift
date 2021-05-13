//
//  FavoriteCompany.swift
//  Digin
//
//  Created by 김예은 on 2021/05/13.
//

import Foundation

struct FavoriteCompany: Decodable {
    var status: String = ""
    var result: [CompanyResult] = []

    private enum CodingKeys: String, CodingKey {
        case status
        case result
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        result = try container.decodeIfPresent([CompanyResult].self, forKey: .result) ?? []
    }
}

// MARK: - Result
struct CompanyResult: Decodable {
    var id: Int = 0
    var stockCode: String = ""
    var name: String = ""

    private enum CodingKeys: String, CodingKey {
        case id
        case stockCode, name
    }

    init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        stockCode = try container.decodeIfPresent(String.self, forKey: .stockCode) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
