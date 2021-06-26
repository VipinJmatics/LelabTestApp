//
//  ApiManager.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import Foundation

//MARK:- ApiErrorCode
enum ApiErrorCode: Int {
    case AuthenticationError = 401
    case ErrorInProcessing = 403
    case ValidationError = 422
    case InternalServerError = 500
    case NotFound = 404
}
//MARK:- API Listing
enum API {
    case fetchContacts
}
enum APIParamsKeys : String {
    case ContentType = "Content-Type"
    case Accept =  "Accept"
    case Authorization = "Authorization"
    case ApplicationJSON = "application/json"
    case Bearer = "Bearer"
    case MimeType = "mimeType"
    case MultipartFormData = "multipart/form-data"
    case Params = "params"
    case Name  = "name"
    case Value = "value"
}
extension API: Endpoint {
    var base: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .fetchContacts: return "/users"
            
        }
    }
    
    var method: APIMethod? {
        switch self {
        case .fetchContacts:
            return .GET
        default:
            return .GET
        }
    }
    var httpHeader: [String:String]? {
        
        return [APIParamsKeys.ContentType.rawValue : APIParamsKeys.ApplicationJSON.rawValue, APIParamsKeys.Accept.rawValue :             APIParamsKeys.ApplicationJSON.rawValue]
    }
}
//MARK:- BASE API MANAGER INIT
class BaseAPIClient: APIClient{
    let session: URLSession
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
}
//MARK:- API MANAGER
// Fetching contact list from server

class FetchContactAPIClient: BaseAPIClient {
    func fetchContactApi(api: API, completion: @escaping (Result<[ContactModel?], APIError>) -> Void) {
        var httpBody:[String : Any]? = nil
        switch api {
        case .fetchContacts:
            break
        default:
            httpBody = nil
        //httpHeaderParams = nil
        }
        let apiRequest = api.prepareRequest(headerParam: api.httpHeader, bodyParam: httpBody)
        fetch(with: apiRequest , decode: { json -> [ContactModel?] in
            guard let apiResult = json as? [ContactModel] else { return  [] }
            
            return apiResult
        }, completion: completion)
    }
}
