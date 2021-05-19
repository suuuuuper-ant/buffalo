//
//  APIService.swift
//  Digin
//
//  Created by 김예은 on 2021/05/12.
//

import Foundation

protocol APIServie {}

extension APIServie {

    static func url(_ path: String) -> String {
        return "http://3.35.143.195" + path
    }

    // MARK: - String -> Dictionary(JSON)
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
