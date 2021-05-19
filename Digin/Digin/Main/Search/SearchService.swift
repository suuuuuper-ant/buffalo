//
//  SearchService.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import Foundation

struct SearchService: APIServie {

    // MARK: - 검색 (GET)
    static func getSearchData(searchText: String, completion: @escaping (SearchResult) -> Void) {
        let path = "/search?"

        var urlComponents = URLComponents(string: url(path))
        let searchQuery = URLQueryItem(name: "keyword", value: searchText)
        urlComponents?.queryItems?.append(searchQuery)

        guard let stringResult = UserDefaults.standard.string(forKey: "userToken")  else { return }
        let jsonResult = convertToDictionary(text: stringResult)
        guard let token = jsonResult?["result"] as? String else { return }

        let headers: [HTTPHeader] = [(value: token, field: "X-AUTH-TOKEN")]

        NetworkRouter.shared.get(urlComponents?.string ?? "", headers: headers, model: Search.self) { (result) in

            switch result {
            case .success(let resultData):

                let data = resultData.result
                completion(data)

            case .failure(let error):
                print(error.localizedDescription)

            }
        }
    }

}
