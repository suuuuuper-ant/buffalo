//
//  Company.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/25.
//

import Foundation

struct HomeCompany: Decodable {
    let data: [Company]
}

struct Company: Decodable {
    let interestingCompany: String
    let tags: [String]
    let isFavorite: Bool
    let currentPrice: String
    let targetPrice: String

}
