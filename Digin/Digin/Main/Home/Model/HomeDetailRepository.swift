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
        guard let token = UserDefaults.standard.value(forKey: "userToken") as? String else { return nil

        }
        let url = "http://3.35.143.195" + "/home" + "/\(companyId)"
            let headers: [HTTPHeader] = [(value: token, field: "X-AUTH-TOKEN")]

        return NetworkCombineRouter.shared.get(url: url, headers: headers, type: HomeDetailResult.self)

    }

}
