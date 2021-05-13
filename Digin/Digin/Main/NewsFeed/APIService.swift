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
}
