//
//  SimpleCompanyRepository.swift
//  Digin
//
//  Created by jinho jeong on 2021/12/04.
//

import Foundation
import Combine

struct HomeCompanyInfoResult: Decodable {

    var status: String
    var result: [HomeCompanyInfo] = []

}

protocol SimpleCompanyRepository: APIService {

    func fetch() -> AnyPublisher<HomeCompanyInfoResult, APIError>
}

final class SimpleCompanyRepositoryImpl: SimpleCompanyRepository {
    func fetch() -> AnyPublisher<HomeCompanyInfoResult, APIError> {
        let baseURL = SimpleCompanyRepositoryImpl.url("/companies/simple")

      return NetworkCombineRouter.shared.get(url: baseURL, headers: nil, type: HomeCompanyInfoResult.self)

    }

}
