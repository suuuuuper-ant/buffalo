//
//  HomeRepository.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/25.
//

import Foundation
import Combine

protocol HomeCompaniesRepository {
    func fetchCopanies() -> AnyPublisher<HomeCompany, APIError>?
}

final class HomeCompaniesDataRepository: HomeCompaniesRepository {
    private let localDataSource: CompaniesRemoteDataSource
    func fetchCopanies() -> AnyPublisher<HomeCompany, APIError>? {
        return localDataSource.fetchCopanies()
    }

    public init(localDataSource: CompaniesRemoteDataSource) {
        self.localDataSource = localDataSource
    }

}

//////////////////

protocol CompaniesDataSource {
    func fetchCopanies() -> AnyPublisher<HomeCompany, APIError>?
}
//
//public struct CompaniesLocalDataSource: CompaniesDataSource {
//    let fileName: String = "HomeDummy"
//    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>? {
//
//        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
//          return  AnyPublisher(
//                Fail<HomeCompany, Error>(error: URLError(.cannotOpenFile))
//            )
//        }
//
//        return Just(path)
//            .tryMap { try Data(contentsOf: URL(fileURLWithPath: $0), options: .mappedIfSafe) }
//            .print()
//            .decode(type: HomeCompany.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//
//    }
//
//}

public struct CompaniesRemoteDataSource: CompaniesDataSource {
    func fetchCopanies() -> AnyPublisher<HomeCompany, APIError>? {

    let url = "http://3.35.143.195" + "/home"
        let headers: [HTTPHeader] = [(value: "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE4IiwibmFtZSI6InN0cmluZyIsInJvbGUiOiJVU0VSIiwic3ViIjoic3RyaW5nIiwiaWF0IjoxNjI4MDkwNDAyLCJleHAiOjI2MjgwOTA0MDJ9.piXz9zaQhbk4aqXHasGTT6SbLH9CrQofWSzbaFVWcx0", field: "X-AUTH-TOKEN")]
     return NetworkCombineRouter.shared.get(url: url, headers: headers, type: HomeCompany.self)

    }
}
