//
//  NetworkModule.swift
//  Digin
//
//  Created by jinho jeong on 2021/04/05.
//

import UIKit

struct ResponseErrorBody: Decodable {
    var status: String
    var code: String
    var path: String
    var message: String
    var timestamp: String
}

/**
 - HTTPHeader 값을 저장하고 운반하기위한 컨테이너 Tuple
 */
typealias HTTPHeader = (value: String, field: String)

/**
 - api call 할때 쓰는 http method  call 객체
 */
class NetworkRouter {
    static let shared = NetworkRouter()
    /**
    - HTTPBody에서 담아 보낼 데이터가 있다면 사용하는 메서드
     - parameters:
        - url: api  요청을하는 url 문자열
        - body: post http메서드로 호출 시 httpBody에 들어갈 key value 값
        - headers: api 호출 시 헤더에 들어갈 값들  **HTTPHeader**
        - model: Decodable을 따르는 모델을 타입을 말하며, 네트워크에서 결과값은 기본적으로 Decodable을 따르는 모델로 넣음
        - timeoutInterval: api 호출 시 응답대기신간을 말하며 기본적으로 URLRequest의 기본시간을 60초를 기본값으로 설정 해놓음
        - completionHandler: Swift의 Result enum을 사용하며, 결과값을 파싱한 타입으로 반환 하는 것과 결과값이 실패했을 때 Error타입으로 보내줌
     */
    func post<T: Decodable>(_ url: String, body: [String: Any]?, headers: [HTTPHeader]?, model: T.Type, timeoutInterval: TimeInterval = 60, completionHandler: @escaping ((Result<T, Error>) -> Void)) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let requestBody = body, let body = try? JSONSerialization.data(withJSONObject: requestBody) {
            request.httpBody = body
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = timeoutInterval
        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.field)
            }
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(model.self, from: data)
             //   let result = try? String(decoding: data, as: UTF8.self) as? T
                completionHandler(.success(result))
            } catch let error {
                completionHandler(.failure(error))
            }
        }.resume()
    }

    func post(_ url: String, body: [String: Any]?, headers: [HTTPHeader]?, timeoutInterval: TimeInterval = 60, completionHandler: @escaping ((Result<String, Error>) -> Void)) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let requestBody = body, let body = try? JSONSerialization.data(withJSONObject: requestBody) {
            request.httpBody = body
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = timeoutInterval
        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.field)
            }
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {

                do {
                    let erorrMessage = try decoder.decode(ResponseErrorBody.self, from: data).message
                    completionHandler(.failure(APIError.apiError(reason: erorrMessage)))
                } catch {
                    completionHandler(.failure(APIError.apiError(reason: "네트워크 에러가 발생했습니다.")))
                }
                return
            }

            do {
               // let result = try decoder.decode(model.self, from: data)
                let result = try String(decoding: data, as: UTF8.self)
                completionHandler(.success(result))
            } catch let error {
                completionHandler(.failure(error))
            }
        }.resume()
    }
    /**
     - 단순 데이터 조회를 해야하는 용도로 사용하는 메서드
     - parameters:
        - url: api  요청을하는 url 문자열
        - headers: api 호출 시 헤더에 들어갈 값들  **HTTPHeader**
        - model: Decodable을 따르는 모델을 타입을 말하며, 네트워크에서 결과값은 기본적으로 Decodable을 따르는 모델로 넣음
        - timeoutInterval: api 호출 시 응답대기신간을 말하며 기본적으로 URLRequest의 기본시간을 60초를 기본값으로 설정 해놓음
        - completionHandler: Swift의 Result enum을 사용하며, 결과값을 파싱한 타입으로 반환 하는 것과 결과값이 실패했을 때 Error타입으로 보내줌
     */
    func get<T: Decodable>(_ url: String, headers: [HTTPHeader]?, model: T.Type, timeoutInterval: TimeInterval = 60, completionHandler: @escaping ((Result<T, Error>) -> Void)) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = timeoutInterval
        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.field)
            }
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(model.self, from: data)
                completionHandler(.success(result))
            } catch let error {
                completionHandler(.failure(error))
            }
        }.resume()
    }
    /**
     -   현재 api의 수정 시간을 가져올 때 사용 ex) 이미지 URL의 변경시간을 가져오고 싶을때..
     - parameters:
        - url: api  요청을하는 url 문자열
        - headers: api 호출 시 헤더에 들어갈 값들  **HTTPHeader**
        - timeoutInterval: api 호출 시 응답대기신간을 말하며 기본적으로 URLRequest의 기본시간을 60초를 기본값으로 설정 해놓음
        - completionHandler: Swift의 Result enum을 사용하며, 결과값을  헤더에서 마지막 수정시간을 반환하는 문자열, 결과값이 실패했을 때 Error타입으로 보내줌
     */
    func head(_ url: String, timeoutInterval: TimeInterval = 60, completionHandler: @escaping ((Result<String, Error>) -> Void)) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = timeoutInterval
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, data != nil else {
                if let error = error {
                    completionHandler(.failure(error))
                }
                return
            }
            guard let lastModified = response.allHeaderFields["Last-Modified"] as? String else { return }
            completionHandler(.success(lastModified))
        }.resume()
    }
}
