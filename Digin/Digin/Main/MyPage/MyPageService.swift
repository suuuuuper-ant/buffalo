//
//  MyPageService.swift
//  Digin
//
//  Created by 김예은 on 2021/05/28.
//

import Foundation

struct MyPageService: APIService {

    static func getMyPageData(completion: @escaping (AccountResult) -> Void) {
        let path = "/accounts"

        guard let stringResult = UserDefaults.standard.string(forKey: "userToken")  else { return }
        let jsonResult = convertToDictionary(text: stringResult)
        guard let token = jsonResult?["result"] as? String else { return }

        let headers: [HTTPHeader] = [(value: token, field: "X-AUTH-TOKEN")]

        NetworkRouter.shared.get(url(path), headers: headers, model: Account.self) { (result) in

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
