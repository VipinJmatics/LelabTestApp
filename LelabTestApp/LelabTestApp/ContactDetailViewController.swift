//
//  ContactDetailViewController.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import UIKit

class ContactDetailViewController: UIViewController {
    var contactDetail: ContactModel?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        resetUI()
        updateDetailsOnCellUI()
    }
    
    @IBAction func backBttnClicked(_ sender: UIButton) {
        dismiss (animated: true, completion: nil)
    }
    
    private func resetUI(){
        self.nameLabel.text = ""
        self.phoneLabel.text = ""
        self.userNameLabel.text = ""
        self.emailLabel.text = ""
        self.websiteLabel.text = ""
        self.addressLabel.text = ""
        self.companyLabel.text = ""
    }
    private func updateDetailsOnCellUI(){
        if let contactObj = self.contactDetail{
            self.nameLabel.text = contactObj.name
            self.phoneLabel.text = contactObj.phone
            self.userNameLabel.text = contactObj.username
            self.emailLabel.text = contactObj.email
            self.websiteLabel.text = contactObj.website
            self.addressLabel.text = self.getconcatenatedAddress(address: contactObj.address)
            self.companyLabel.text = self.getconcatenatedCompanyDetail(company: contactObj.company)
            
        }
    }
    
    /// Functions to concatenate Address and Company details
    
    private func getconcatenatedAddress(address:Address?) -> String?{
        let fullAddress = "\((address?.street ?? "") + ",\n")\((address?.suite ?? "") + ",\n")\((address?.city ?? "") + ",\n")\(address?.zipcode ?? "")"
        return fullAddress
    }
    private func getconcatenatedCompanyDetail(company:Company?) -> String?{
        let companyDetail = "\((company?.name ?? "") + ",\n")\((company?.catchPhrase ?? "") + ",\n")\(company?.bs ?? "")"
        return companyDetail
    }
    
    
}
