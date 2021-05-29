//
//  Account.swift
//  Digin
//
//  Created by 김예은 on 2021/05/28.
//

import Foundation

struct Account: Decodable {
    var status: String = ""
    var result: AccountResult = AccountResult()

    private enum CodingKeys: String, CodingKey {
        case status
        case result
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        result = try container.decodeIfPresent(AccountResult.self, forKey: .result) ?? AccountResult()
    }
}

struct AccountResult: Codable {
    var email: String = ""
    var name: String = ""

    init() {}
}
