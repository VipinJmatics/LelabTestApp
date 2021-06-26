//
//  Constants.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import UIKit

let ApplicationDelegate =
    UIApplication.shared.delegate as! AppDelegate
let kAPP_TITLE = "LeLab"
enum AlertMessage : String {
    case NoNetworkMessage = "Please check your network connection."
    case ApiErrorMessage = "Something went wrong. Please try later."
    case NoDataFromServer = "No data available. Please try later."

}
enum UserDefaultsKeys : String {
    case kEmployeeDetails = "contactDetails"
}
