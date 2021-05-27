//
//  NewsFeed.swift
//  Digin
//
//  Created by 김예은 on 2021/05/12.
//

import Foundation

// MARK: - NewsFeed
struct Newsfeed: Decodable {
    var status: String = ""
    var result: NewsfeedResult = NewsfeedResult()

    private enum CodingKeys: String, CodingKey {
        case status
        case result
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        result = try container.decodeIfPresent(NewsfeedResult.self, forKey: .result) ?? NewsfeedResult()
    }
}

// MARK: - Result
struct NewsfeedResult: Decodable {
    var totalPages: Int = 0
    var totalElements: Int = 0
    var number: Int = 0
    var size: Int = 0
    var numberOfElements: Int = 0
    var content: [NewsfeedContent] = []
    var sort: NewsfeedSort = NewsfeedSort()
    var first: Bool = false
    var last: Bool = false
    var pageable: String = ""
    var empty: Bool = false

    private enum CodingKeys: String, CodingKey {
        case totalPages, totalElements, number, size
        case numberOfElements
        case content
        case sort
        case first, last
        case pageable
        case empty
    }

    init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
        totalElements = try container.decodeIfPresent(Int.self, forKey: .totalElements) ?? 0
        number = try container.decodeIfPresent(Int.self, forKey: .number) ?? 0
        size = try container.decodeIfPresent(Int.self, forKey: .size) ?? 0
        numberOfElements = try container.decodeIfPresent(Int.self, forKey: .numberOfElements) ?? 0
        content = try container.decodeIfPresent([NewsfeedContent].self, forKey: .content) ?? []
        sort = try container.decodeIfPresent(NewsfeedSort.self, forKey: .sort) ?? NewsfeedSort()
        first = try container.decodeIfPresent(Bool.self, forKey: .first) ?? false
        last = try container.decodeIfPresent(Bool.self, forKey: .last) ?? false
        pageable = try container.decodeIfPresent(String.self, forKey: .pageable) ?? ""
        empty = try container.decodeIfPresent(Bool.self, forKey: .empty) ?? false
    }
}

// MARK: - Content
struct NewsfeedContent: Decodable {
    var id: Int = 0
    var stockCode: String = ""
    var title: String = ""
    var link: String = ""
    var description: String = ""
    var createdAt: String = ""
    var imageUrl: String = ""

    private enum CodingKeys: String, CodingKey {
        case id, stockCode, title, link
        case description, imageUrl
        case createdAt, updatedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        stockCode = try container.decodeIfPresent(String.self, forKey: .stockCode) ?? ""
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        link = try container.decodeIfPresent(String.self, forKey: .link) ?? ""
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
    }
}

// MARK: - Pageable
//struct NewsfeedPageable: Decodable {
//    var paged: Bool = false
//    var unpaged: Bool = false
//    var pageNumber: Int = 0
//    var pageSize: Int = 0
//    var offset: Int = 0
//    var sort: NewsfeedSort = NewsfeedSort()
//
//    private enum CodingKeys: String, CodingKey {
//        case paged, unpaged
//        case pageNumber, pageSize, offset
//        case sort
//    }
//
//    init() {}
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        paged = try container.decodeIfPresent(Bool.self, forKey: .paged) ?? false
//        unpaged = try container.decodeIfPresent(Bool.self, forKey: .unpaged) ?? false
//        pageNumber = try container.decodeIfPresent(Int.self, forKey: .pageNumber) ?? 0
//        pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) ?? 0
//        offset = try container.decodeIfPresent(Int.self, forKey: .offset) ?? 0
//        sort = try container.decodeIfPresent(NewsfeedSort.self, forKey: .sort) ?? NewsfeedSort()
//    }
//}

// MARK: - Sort
struct NewsfeedSort: Decodable {
    var sorted: Bool = false
    var unsorted: Bool = false
    var empty: Bool = false

    private enum CodingKeys: String, CodingKey {
        case sorted, unsorted, empty
    }

    init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sorted = try container.decodeIfPresent(Bool.self, forKey: .sorted) ?? false
        unsorted = try container.decodeIfPresent(Bool.self, forKey: .unsorted) ?? false
        empty = try container.decodeIfPresent(Bool.self, forKey: .empty) ?? false
    }
}

// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
