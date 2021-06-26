//
//  ListTableViewCell.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    lazy var viewModel:ContactTableCellViewModel = {
        [unowned self] in
        let vm = ContactTableCellViewModel()
        vm.contact = nil
        return vm
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.resetUI()
        self.viewModel.delegate = self
        containerView.superview?.addShadowWithColour(shadowColor: UIColor.lightGray)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    private func resetUI(){
        self.nameLabel.text = ""
        self.phoneLabel.text = ""
    }
    private func updateDetailsOnCellUI(){
        if let contactObj = self.viewModel.contact{
            self.nameLabel.text = contactObj.name
            self.phoneLabel.text = contactObj.phone
        }
    }
}
extension ListTableViewCell:ContactTableCellViewModelDelegate{
    func updateUI() {
        self.resetUI()
        self.updateDetailsOnCellUI()
    }
}
