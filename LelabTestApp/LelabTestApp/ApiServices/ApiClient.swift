//
//  ApiClient.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//


import UIKit
import Foundation

//MARK:- API Client - Enums
enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
enum APIMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case networkFailure
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .networkFailure: return "Network Failure"
        }
    }
}
//MARK:- API Client - EndPoint

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var method: APIMethod? { get }
    func prepareRequest(headerParam:[String: String]?, bodyParam: Any?) -> URLRequest
}
extension Endpoint {
    private func bodyData(bodyParam:Any?) -> Data? {
        guard let body = bodyParam else {
            return nil
        }
        let httpData = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        return httpData
    }
    private var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        return components
    }
    func prepareRequest(headerParam:[String: String]?, bodyParam: Any?) -> URLRequest{
        let url = URL(string: (base+path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        var req = URLRequest(url: url)
        if let methodType = method{
            req.httpMethod = methodType.rawValue
            if let tBody = bodyParam {
                if let bodyData = tBody as? Data{
                    req.httpBody = bodyData
                }else{
                    do {
                        req.httpBody = try JSONSerialization.data(withJSONObject: tBody, options: JSONSerialization.WritingOptions.prettyPrinted)
                    }
                    catch {
                        print("Invalid body format")
                    }
                }
            }
        }else{
            req.httpMethod = APIMethod.GET.rawValue
        }
        if let httpHeaderParams = headerParam{
            for (key, value) in httpHeaderParams {
                req.addValue(value, forHTTPHeaderField: key)
            }
        }
        return req
    }
}

//MARK:- API Client
protocol APIClient {
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
}
extension APIClient {
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                // Checking for network connection
                // Will retrieve saved cotact list if no network is available
                if !Utils.isConnectedToNetwork(){
                    if let savedContactList = UserDefaults.getContactDetails(){
                        completion(savedContactList, nil)
                    }
                    else{
                        completion(nil, .networkFailure)
                    }
                }
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        //print("Decoding JSON ============ ")
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    }catch {
                        print("error: ", error)
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
            //MARK: change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
}

