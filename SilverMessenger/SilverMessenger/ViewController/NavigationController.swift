//
//  NavigationController.swift
//  SilverMessenger
//
//  Created by Khiem Ngo Viet on 10/10/14.
//  Copyright (c) 2014 exteam.com. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, AuthenticateDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSettingValue()
        let keychain = GlobalVariable.shareInstance.loadKeychain()
        if keychain == nil{
            //navigate to Login view
            self.navigateToLoginView()
        }
        else {
            //Do login to websocket
            MessageSocket.sharedInstance.delegateAuthen = self
            MessageSocket.sharedInstance.authenticateUser(keychain!.companyId, userName: keychain!.username, pwd: keychain!.pwd)
        }
    }
    
    func didAuthenticate(success: Bool) {
        if success{
            //Navigate to Contact view
            let vcTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as TabBarViewController
            self.pushViewController(vcTabBar, animated: true)
        }
        else{
            self.navigateToLoginView()
        }
    }

    func navigateToLoginView(){
        let vcLogin = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
        self.pushViewController(vcLogin, animated: true)
    }
    
    func initSettingValue(){
        let contactStatus: AnyObject? = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.statusKey)
        let hideOfflineSetting: AnyObject? = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.hideOfflineKey)
        let enabledSound: AnyObject? = GlobalVariable.shareInstance.getDefaultValue(GlobalVariable.shareInstance.enabledSoundKey)
        if contactStatus == nil {
            GlobalVariable.shareInstance.setDefaultValue(GlobalVariable.shareInstance.statusKey, value: ContactStatusEnum.Online.rawValue)
        }
        if hideOfflineSetting == nil{
            GlobalVariable.shareInstance.setDefaultValue(GlobalVariable.shareInstance.hideOfflineKey, value: false)
        }
        if enabledSound == nil{
            GlobalVariable.shareInstance.setDefaultValue(GlobalVariable.shareInstance.enabledSoundKey, value: true)
        }

    }
}
