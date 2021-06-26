//
//  ContactTableCellViewModel.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import Foundation

protocol ContactTableCellViewModelProtocol:AnyObject {
    var contact: ContactModel? { get }
}
protocol ContactTableCellViewModelDelegate : AnyObject {
    func updateUI()
}
class ContactTableCellViewModel: ContactTableCellViewModelProtocol{
    weak var delegate:ContactTableCellViewModelDelegate?
    var contact: ContactModel? {
        didSet{
            self.delegate?.updateUI()
        }
    }
}
