//
//  APIManager.swift
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case GET
}

// MARK: Error handling by CustomError and StatusCode enums

enum CustomError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Int)
    case dataError
    case urlSession
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "Invalid Response received"
        case .requestFailed(let code):
            let statusCode = StatusCode(rawValue: code) ?? .unknown
            return "\(statusCode.description)"
        case .dataError:
            return "Data error occurred"
        case .urlSession:
            return "Missing Internet connection!"
        case .decodingError:
            return "Error decoding"
        }
    }
}

enum StatusCode: Int {
    case badRequest = 400
    case unauthorized = 401
    case serverError = 500
    case unknown
    
    var description: String {
        switch self {
        case .badRequest:
            return "The request was unacceptable, often due to a missing or misconfigured parameter."
        case .unauthorized:
            return "Your API key was missing from the request, or wasn't correct."
        case .serverError:
            return "Server Error - Something went wrong on our side."
        case .unknown:
            return "Unknown"
        }
    }
}

// MARK: Alamofire GET requests func (informational data and images(icons))

final class APIManager {
    static let shared = APIManager(baseURL: URLExtension.baseURL.rawValue)
    let baseURL: String
    
    private init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func request(endpoint: String, method: HTTPMethod, completion: @escaping (Result<Data, CustomError>) -> Void) {
        let url = baseURL + endpoint
        AF.request(url, method: Alamofire.HTTPMethod(rawValue: method.rawValue))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(.dataError))
                    }
                case .failure(_):
                    completion(.failure(.requestFailed(response.response?.statusCode ?? StatusCode.unknown.rawValue)))
                }
            }
    }
    
    func requstImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
