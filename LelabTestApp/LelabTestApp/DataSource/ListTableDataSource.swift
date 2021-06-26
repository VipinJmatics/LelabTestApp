//
//  ListTableDataSource.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import UIKit

class ListTableDataSource: NSObject,UITableViewDataSource {
    private var contactList:[ContactModel?]?
    init(contactList:[ContactModel?]?) {
        self.contactList = contactList
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if contactList != nil  {
            if let contactArr = self.contactList {
                if contactArr.count == 0 {
                    tableView.setEmptyMessage("List Empty")
                } else {
                    tableView.restore()
                }
                return contactArr.count
            }
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        if let contactArr = self.contactList {
            cell.viewModel.contact = contactArr[indexPath.row]
        }else{
            cell.viewModel.contact = nil
        }
        return cell
    }
    
    
    
}
