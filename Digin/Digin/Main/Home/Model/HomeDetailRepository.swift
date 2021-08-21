//
//  HomeDetailRepository.swift
//  Digin
//
//  Created by jinho jeong on 2021/08/21.
//

import Foundation
import Combine

protocol HomeDetailRepository {
    func getDetailPage() -> AnyPublisher<HomeDetailResult, APIError>?
}

final class DefaultHomeDetailRepository: HomeDetailRepository {

    private var homeDetailDataSource: HomeDetailDataSource
    private var companyApiInfo: HomeCompanyInfo
    init(homeDetailDataSource: HomeDetailDataSource, company: HomeCompanyInfo) {
        self.homeDetailDataSource = homeDetailDataSource
        self.companyApiInfo = company
    }

    func getDetailPage() -> AnyPublisher<HomeDetailResult, APIError>? {

        let companyId = String(companyApiInfo.stockCode)

     return homeDetailDataSource.loadToCompanyDetailInfo(companyId: companyId)
    }
}

protocol HomeDetailDataSource {

    func loadToCompanyDetailInfo(companyId: String) -> AnyPublisher<HomeDetailResult, APIError>?
}

final class DefaultHomeDetailDataSource: HomeDetailDataSource {
    func loadToCompanyDetailInfo(companyId: String) -> AnyPublisher<HomeDetailResult, APIError>? {
        let url = "http://3.35.143.195" + "/home" + "/\(companyId)"
            let headers: [HTTPHeader] = [(value: "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE4IiwibmFtZSI6InN0cmluZyIsInJvbGUiOiJVU0VSIiwic3ViIjoic3RyaW5nIiwiaWF0IjoxNjI4MDkwNDAyLCJleHAiOjI2MjgwOTA0MDJ9.piXz9zaQhbk4aqXHasGTT6SbLH9CrQofWSzbaFVWcx0", field: "X-AUTH-TOKEN")]

        return NetworkCombineRouter.shared.get(url: url, headers: headers, type: HomeDetailResult.self)

    }

}
