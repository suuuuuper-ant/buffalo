//
//  CombineNetworkModule.swift
//  Digin
//
//  Created by jinho jeong on 2021/05/17.
//

import Foundation
import Combine

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String)
    case urlStringError
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        case .urlStringError:
            return "url String Error"
        }

    }
}

class NetworkCombineRouter {
    static let shared = NetworkCombineRouter()

    typealias HTTPHeader = (value: String, field: String)

    var disposeBag = Set<AnyCancellable>()
    static let defaultInterval: TimeInterval = 60

    func get<T: Decodable>(_ url: String, param: [String: Any], type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            return AnyPublisher(Fail<T, Error>(error: URLError(.unsupportedURL)))
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: NetworkCombineRouter.defaultInterval)

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError {
                return URLError(URLError.Code(rawValue: $0.errorCode))
            }
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

    }

    func get<T: Decodable>(url: String, headers: [HTTPHeader]? = nil, type: T.Type) -> AnyPublisher<T, APIError> {
        return Just(url)
            .map {url in
                URL(string: url)!}
            .setFailureType(to: URLError.self)
            .map({ url -> URLRequest in
                var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
                request.httpMethod = "GET"
                if let headers = headers {
                    for header in headers {
                        request.setValue(header.value, forHTTPHeaderField: header.field)
                    }
                }
                return request
            })
            .flatMap({ url in return URLSession.shared.dataTaskPublisher(for: url)})
            .tryMap({ output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return output.data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    if let error = error as? APIError {
                        return error
                    } else {
                        return APIError.apiError(reason: error.localizedDescription)
                    }

                }
            }.eraseToAnyPublisher()
    }

    func get<T: Decodable>(url: URL, headers: [HTTPHeader]? = nil, type: T.Type) -> AnyPublisher<T, APIError> {
        return Just(url)
            .setFailureType(to: URLError.self)
            .map({ url -> URLRequest in
                var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
                request.httpMethod = "GET"
                if let headers = headers {
                    for header in headers {
                        request.setValue(header.value, forHTTPHeaderField: header.field)
                    }
                }
                return request
            })
            .flatMap({ url in return URLSession.shared.dataTaskPublisher(for: url)})
            .tryMap({ output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return output.data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    if let error = error as? APIError {
                        return error
                    } else {
                        return APIError.apiError(reason: error.localizedDescription)
                    }

                }
            }.eraseToAnyPublisher()
    }

    func post<T: Decodable>(url: String, headers: [HTTPHeader]? = nil, params: [String: Any]?, type: T.Type) -> AnyPublisher<T, APIError> {
        return Just(url)
            .map {url in
                URL(string: url)!}
            .setFailureType(to: URLError.self)
            .map { url -> URLRequest in
                var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

                if let requestBody = params, let body = try? JSONSerialization.data(withJSONObject: requestBody) {
                    request.httpBody = body
                }
                return request
            }
            .flatMap({ request in return URLSession.shared.dataTaskPublisher(for: request)})
            .tryMap({ output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return output.data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    if let error = error as? APIError {
                        return error
                    } else {
                        return APIError.apiError(reason: error.localizedDescription)
                    }

                }
            }.eraseToAnyPublisher()
    }

    func head(url: String, headers: [HTTPHeader]? = nil, params: [String: Any]?) -> AnyPublisher<String, APIError> {
        return Just(url)
            .map {url in
                URL(string: url)!}
            .setFailureType(to: URLError.self)
            .map { url -> URLRequest in
                var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
                request.httpMethod = "HEAD"
                if let headers = headers {
                    for header in headers {
                        request.setValue(header.value, forHTTPHeaderField: header.field)
                    }
                }
                return request
            }
            .flatMap({ request in return URLSession.shared.dataTaskPublisher(for: request)})
            .tryMap({ output -> String in
                guard let httpResponse = output.response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                guard let lastModified = httpResponse.allHeaderFields["Last-Modified"] as? String else { throw APIError.unknown }
                return lastModified
            })
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    if let error = error as? APIError {
                        return error
                    } else {
                        return APIError.apiError(reason: error.localizedDescription)
                    }

                }
            }.eraseToAnyPublisher()
    }

}
