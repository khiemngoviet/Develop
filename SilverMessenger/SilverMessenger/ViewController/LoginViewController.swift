//
//  LoginViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/27/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AuthenticateDelegate {
    
    @IBOutlet var companyIdTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func validateUserInfo() -> Bool {
        return !companyIdTextField.text.isEmpty && !userNameTextField.text.isEmpty && !passwordTextField.text.isEmpty
    }
    
    @IBAction func loginTouched(sender: UIButton) {
        if validateUserInfo() {
            activityIndicator.startAnimating()
            MessageSocket.sharedInstance.delegateAuthen = self
            MessageSocket.sharedInstance.authenticateUser(companyIdTextField.text, userName: userNameTextField.text, pwd: passwordTextField.text)
        }
    }
    
    func animateActivityIndicator(state: Bool) {
        if state{
            activityIndicator.startAnimating()
        }
        else{
            activityIndicator.stopAnimating()
        }
    }
    
    func didAuthenticate(success: Bool) {
        activityIndicator.stopAnimating()
        if success {
            GlobalVariable.shareInstance.loginInfo.userName = userNameTextField.text
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let tabVC = sb.instantiateViewControllerWithIdentifier("TabBarController") as UITabBarController
            self.navigationController?.pushViewController(tabVC, animated: true)
        } else {
            // Show message
            let alert = UIAlertView(title: "", message: "Login failed.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}

enum LoginStatus{
    case Fail, Success
}

enum MessageIndicator: String{
    case IsAuthenticate = "IsAuthenticate"
    case ContactList = "ContactList"
    case StatusChange = "StatusChange"
    case Message = "Message"
    case MessageOffline = "MessageOffline"
}

enum ContactStatusEnum: String {
    case Online = "Online"
    case Offline = "Offline"
    case Invisible = "Invisible"
    case Away = "Away"
    case DoNotDisturb = "DoNotDisturb"
}


class Contact{
    
    var name:String
    var status: ContactStatusEnum
    var shortMessage: String
    var bubbleData = [NSBubbleData]()
    var showIndicator:Bool = false
    var isInConversation:Bool = false
    
    init(name: String, status: ContactStatusEnum, shortMessage: String){
        self.name = name
        self.status = status
        self.shortMessage = shortMessage
    }
    
    
}
