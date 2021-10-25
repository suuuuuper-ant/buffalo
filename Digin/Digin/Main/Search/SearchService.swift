//
//  SearchService.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import Foundation

struct SearchService: APIServie {

    // MARK: - 검색 (GET)
    static func getSearchData(searchText: String, completion: @escaping (Result<[HomeCompanyInfo], Error>) -> Void) {
        let path = "/companies/search?"

        var urlComponents = URLComponents(string: url(path))
        let searchQuery = URLQueryItem(name: "keyword", value: searchText)
        urlComponents?.queryItems?.append(searchQuery)

        guard let stringResult = UserDefaults.standard.string(forKey: "userToken")  else { return }
//        let jsonResult = convertToDictionary(text: stringResult)
//        guard let token = jsonResult?["result"] as? String else { return }

        let headers: [HTTPHeader] = [(value: stringResult, field: "X-AUTH-TOKEN")]
        print("search: \(urlComponents?.url)")
        NetworkRouter.shared.get(urlComponents?.string ?? "", headers: headers, model: Search.self) { (result) in

            switch result {
            case .success(let resultData):

                let data = resultData.result
                completion(.success(resultData.result))

            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)

            }
        }
    }

    static func getSearchNewsData(searchText: String, completion: @escaping  (Result<SearchNews, Error>) -> Void) {
        let path = "/news/search?"

        var urlComponents = URLComponents(string: url(path))
        let searchQuery = URLQueryItem(name: "keyword", value: searchText)
        urlComponents?.queryItems?.append(searchQuery)

        guard let stringResult = UserDefaults.standard.string(forKey: "userToken")  else { return }
//        let jsonResult = convertToDictionary(text: stringResult)
//        guard let token = jsonResult?["result"] as? String else { return }

        let headers: [HTTPHeader] = [(value: stringResult, field: "X-AUTH-TOKEN")]
        print("search: \(urlComponents?.url)")
        NetworkRouter.shared.get(urlComponents?.string ?? "", headers: headers, model: SearchNews.self) { (result) in

            switch result {
            case .success(let resultData):

                let data = resultData.result
                completion(.success(resultData))

            case .failure(let error):
                completion(.failure(error))

            }
        }
    }

}
