//
//  Search.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import Foundation

// MARK: - Search
struct Search: Decodable {
    var status: String = ""
    var result: SearchResult = SearchResult()

    private enum CodingKeys: String, CodingKey {
        case status
        case result
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        result = try container.decodeIfPresent(SearchResult.self, forKey: .result) ?? SearchResult()
    }
}

// MARK: - Result
struct SearchResult: Decodable {
    var companies: [SearchCompany] = []
    var news: [SearchNews] = []

    init() {}

    private enum CodingKeys: String, CodingKey {
        case companies
        case news
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        companies = try container.decodeIfPresent([SearchCompany].self, forKey: .companies) ?? []
        news = try container.decodeIfPresent([SearchNews].self, forKey: .news) ?? []
    }
}

// MARK: - Company
struct SearchCompany: Decodable {
    var id: Int = 0
    var name: String = ""
    var stockCode: String = ""
    var likeCount: Int = 0
    var imageUrl: String = ""

    init() {}

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case stockCode
        case likeCount
        case imageUrl
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        stockCode = try container.decodeIfPresent(String.self, forKey: .stockCode) ?? ""
        likeCount = try container.decodeIfPresent(Int.self, forKey: .likeCount) ?? 0
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
    }
}

// MARK: - News
struct SearchNews: Codable {
    var id: Int = 0
    var stockCode: String = ""
    var title: String = ""
    var link: String = ""
    var description: String = ""
    var createdAt: String
    var imageUrl: String

}
