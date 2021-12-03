//
//  SearchNewsRepository.swift
//  Digin
//
//  Created by jinho jeong on 2021/12/03.
//

import Foundation
import Combine

protocol SearchNewsRepository: APIService {

    func fetch(keyword: String) -> AnyPublisher<SearchListResult, APIError>?
}

final class SearchNewsRepositoryImpl: SearchNewsRepository {
    func fetch(keyword: String) -> AnyPublisher<SearchListResult, APIError>? {
        let baseURL = SearchNewsRepositoryImpl.url("/news/search?")
        var urlComponent = URLComponents(string: baseURL)

        let keyworQueryItem = URLQueryItem(name: "keyword", value: keyword)

        urlComponent?.queryItems?.append(keyworQueryItem)

        guard let token = UserDefaults.standard.value(forKey: "userToken") as? String else { return nil

        }
        guard  let percentedString = urlComponent?.url?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  else {
            return  AnyPublisher(Fail<SearchListResult, APIError>(error: APIError.urlStringError))
        }
        guard let url = urlComponent?.url
                else { return  AnyPublisher(Fail<SearchListResult, APIError>(error: APIError.urlStringError)) }
        let headers: [HTTPHeader] = [(value: token, field: "X-AUTH-TOKEN")]

       return NetworkCombineRouter.shared.get(url: url, headers: headers, type: SearchListResult.self)

    }

}
