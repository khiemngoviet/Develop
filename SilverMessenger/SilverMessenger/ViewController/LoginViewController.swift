//
//  LoginViewController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 9/27/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit
import Security

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
            self.saveToKeyChain()
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
    
    func saveToKeyChain(){
        KeychainWrapper.delete(GlobalVariable.shareInstance.companyKey)
        KeychainWrapper.delete(GlobalVariable.shareInstance.usernameKey)
        KeychainWrapper.delete(GlobalVariable.shareInstance.passwordKey)
        KeychainWrapper.save(GlobalVariable.shareInstance.companyKey, data: companyIdTextField.text)
        KeychainWrapper.save(GlobalVariable.shareInstance.usernameKey, data: userNameTextField.text)
        KeychainWrapper.save(GlobalVariable.shareInstance.passwordKey, data: passwordTextField.text)
    }
    
    @IBAction func viewInsideTapped(sender: UITapGestureRecognizer) {
        userNameTextField.resignFirstResponder()
        companyIdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
   
    @IBAction func viewContainerTapped(sender: UITapGestureRecognizer) {
        userNameTextField.resignFirstResponder()
        companyIdTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}




