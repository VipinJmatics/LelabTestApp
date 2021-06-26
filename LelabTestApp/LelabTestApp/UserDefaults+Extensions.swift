//
//  UserDefaults+Extensions.swift
//  LelabTestApp
//
//  Created by vipin v on 26/06/21.
//

import Foundation

protocol ObjectSavable {
    func setObject<T>(_ object: T, forKey: String) throws where T: Encodable
    func getObject<T>(forKey: String, castTo type: T.Type) throws -> T where T: Decodable
}
extension UserDefaults {
    
    
    class func saveContactDetails(userData: [ContactModel?]) {
        let userDefaults = UserDefaults.standard
        do {
            try
                userDefaults.setObject(userData, forKey: UserDefaultsKeys.kEmployeeDetails.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func getContactDetails() -> [ContactModel?]?
    {
        let userDefaults = UserDefaults.standard
        do {
            let userObj = try userDefaults.getObject(forKey: UserDefaultsKeys.kEmployeeDetails.rawValue, castTo: [ContactModel?].self)
            //print(userObj)
            return userObj
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension UserDefaults: ObjectSavable {
    enum ObjectSavableError: String, LocalizedError {
        case unableToEncode = "Unable to encode object into data"
        case noValue = "No data object found for the given key"
        case unableToDecode = "Unable to decode object into given type"
        var errorDescription: String? {
            rawValue
        }
    }
    func setObject<T>(_ object: T, forKey: String) throws where T: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<T>(forKey: String, castTo type: T.Type) throws -> T where T: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
