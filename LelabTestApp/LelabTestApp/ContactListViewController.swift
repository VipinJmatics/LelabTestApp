//
//  ContactListViewController.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import UIKit
import RSLoadingView

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var contactListTable: UITableView!
    var contactTableDatasource:ListTableDataSource?
    var refreshControl = UIRefreshControl()
    let loadingView = RSLoadingView()

    lazy var viewModel:ContactListViewModel = {
        [unowned self] in
        let vm = ContactListViewModel()
        return vm
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(getContactDetails), for: .valueChanged)
        contactListTable.addSubview(refreshControl)
        self.contactListTable.layoutIfNeeded()
        self.viewModel.delegate = self
        self.contactListTable.delegate = self
        loadingView.mainColor = .systemTeal
        self.getContactDetails()
    }
    @objc func getContactDetails() {
        loadingView.show(on: self.view)
        self.viewModel.fetchContactList()

    }
}

/// Delegate methodes to handle success and failure cases  of api call

extension ContactListViewController:ContactListViewModelDelegate, UITableViewDelegate{
    func failedToGetContactList() {
        RSLoadingView.hide(from: self.view)
        refreshControl.endRefreshing()
        Utils.alertForMessage(kAPP_TITLE, message: AlertMessage.ApiErrorMessage.rawValue, controller: self)
    }
    
    func fetchedContactListSuccessfully() {
        DispatchQueue.main.async {
            RSLoadingView.hide(from: self.view)
            self.refreshControl.endRefreshing()
            self.contactTableDatasource = ListTableDataSource(contactList:self.viewModel.contactListResult)
            self.contactListTable.dataSource = self.contactTableDatasource
            self.contactListTable.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contactItem = self.viewModel.contactListResult[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        vc.contactDetail = contactItem
        present(vc, animated: true, completion: nil)
        
    }
}
