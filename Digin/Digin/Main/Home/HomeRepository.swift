//
//  HomeRepository.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/25.
//

import Foundation
import Combine

protocol HomeCompaniesRepository {
    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>?
}

final class HomeCompaniesDataRepository: HomeCompaniesRepository {
    private let localDataSource: CompaniesDataSource
    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>? {
        return localDataSource.fetchCopanies()
    }

    public init(localDataSource: CompaniesDataSource) {
        self.localDataSource = localDataSource
    }

}

//////////////////

protocol CompaniesDataSource {
    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>?
}

public struct CompaniesLocalDataSource: CompaniesDataSource {
    let fileName: String = "HomeDummy"
    func fetchCopanies() -> AnyPublisher<HomeCompany, Error>? {

        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
          return  AnyPublisher(
                Fail<HomeCompany, Error>(error: URLError(.cannotOpenFile))
            )
        }

        return Just(path)
            .tryMap { try Data(contentsOf: URL(fileURLWithPath: $0), options: .mappedIfSafe) }
            .print()
            .decode(type: HomeCompany.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

    }

}
