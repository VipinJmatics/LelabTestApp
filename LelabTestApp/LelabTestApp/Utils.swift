//
//  Utils.swift
//  LelabTestApp
//
//  Created by vipin v on 25/06/21.
//

import UIKit
import SystemConfiguration


class Utils: NSObject {
    class func alertForMessage(_ title:String, message:String,controller:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    class func checkNetworkConnectivity(viewController:UIViewController, isAlert:Bool) -> Bool{
        if Utils.isConnectedToNetwork(){
            return true
        }else{
            Utils.alertForMessage(kAPP_TITLE, message: AlertMessage.NoNetworkMessage.rawValue, controller: viewController)
            return false
        }
    }
}
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
    }
}
extension UIView {
    func addShadowWithColour (shadowColor:UIColor)
    {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
    }
}
class PaddedLabel: UILabel {
    
    @IBInspectable var inset:CGSize = CGSize(width: 0, height: 0)
    
    var padding: UIEdgeInsets {
        var hasText:Bool = false
        if let t = self.text?.count, t > 0 {
            hasText = true
        }
        else if let t = attributedText?.length, t > 0 {
            hasText = true
        }
        
        return hasText ? UIEdgeInsets(top: inset.height, left: inset.width, bottom: inset.height, right: inset.width) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let p = padding
        let width = superContentSize.width + p.left + p.right
        let heigth = superContentSize.height + p.top + p.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let p = padding
        let width = superSizeThatFits.width + p.left + p.right
        let heigth = superSizeThatFits.height + p.top + p.bottom
        return CGSize(width: width, height: heigth)
    }
}
