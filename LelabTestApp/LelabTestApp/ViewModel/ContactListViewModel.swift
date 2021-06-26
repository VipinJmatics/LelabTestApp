//
//  ContactListViewModel.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import UIKit

protocol ContactListViewModelProtocol:AnyObject {
    var contactListResult : [ContactModel?] { get }
    
}
protocol ContactListViewModelDelegate : AnyObject {
    func failedToGetContactList()
    func fetchedContactListSuccessfully()
}
class ContactListViewModel: ContactListViewModelProtocol {
    weak var delegate:ContactListViewModelDelegate?
    
    var contactListResult : [ContactModel?] = [] {
        didSet{
            // Saving contact list for offline usage
            // Usually in actual projects this part is done with the help of core data or sqllite
            // But for here for demo purpose it is saved in user defaults
            UserDefaults.saveContactDetails(userData: contactListResult)
            self.delegate?.fetchedContactListSuccessfully()
        }
    }
    
    //Fetching contact list from api
    func fetchContactList(){
        
        let contactApi = FetchContactAPIClient()
        contactApi.fetchContactApi(api: .fetchContacts) { result in
            switch result {
            case .success(let dataObject):
                let contactDetailsData = dataObject
                self.contactListResult = contactDetailsData
                return
            case .failure(let error):
                print("the error \(error)")
                self.delegate?.failedToGetContactList()
                return
            }
        }
        
    }
}
