//
//  NewsFeedService.swift
//  Digin
//
//  Created by 김예은 on 2021/05/12.
//

import Foundation

struct NewsfeedService: APIServie {

    // MARK: - 모든 뉴스 (GET)
    static func getNewsData(pageNumber: Int, completion: @escaping (NewsfeedResult) -> Void) {
        let path = "/news/?page=\(pageNumber)"

        guard let stringResult = UserDefaults.standard.string(forKey: "userToken")  else { return }
        let jsonResult = convertToDictionary(text: stringResult)
        guard let token = jsonResult?["result"] as? String else { return }

        let headers: [HTTPHeader] = [(value: token, field: "X-AUTH-TOKEN")]

        NetworkRouter.shared.get(url(path), headers: headers, model: Newsfeed.self) { (result) in

            switch result {
            case .success(let resultData):

                let data = resultData.result
                completion(data)

            case .failure(let error):
                print(error.localizedDescription)

            }
        }
    }

    // MARK: - 관심 기업 (GET)
    static func getFavorites(completion: @escaping ([CompanyResult]) -> Void) {
        let path = "/accounts/favorites"

        guard let stringResult = UserDefaults.standard.string(forKey: "userToken")  else { return }
        let jsonResult = convertToDictionary(text: stringResult)
        guard let token = jsonResult?["result"] as? String else { return }

        let headers: [HTTPHeader] = [(value: token, field: "X-AUTH-TOKEN")]

        NetworkRouter.shared.get(url(path), headers: headers, model: FavoriteCompany.self) { (result) in

            switch result {
            case .success(let resultData):

                let data = resultData.result
                completion(data)

            case .failure(let error):
                print(error.localizedDescription)

            }
        }
    }

    // MARK: - 기업 뉴스 (GET)
    static func getCompanyNews(stockCode: String, pageNumber: Int, completion: @escaping (NewsfeedResult) -> Void) {
        let path = "/companies/{stockCode}/news?stockCode=\(stockCode)&page=\(pageNumber)"

        guard let stringResult = UserDefaults.standard.string(forKey: "userToken")  else { return }
        let jsonResult = convertToDictionary(text: stringResult)
        guard let token = jsonResult?["result"] as? String else { return }

        let headers: [HTTPHeader] = [(value: token, field: "X-AUTH-TOKEN")]

        NetworkRouter.shared.get(url(path), headers: headers, model: Newsfeed.self) { (result) in

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
