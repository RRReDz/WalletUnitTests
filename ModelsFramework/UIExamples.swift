//
//  UIExamples.swift
//  ModelsFramework
//
//  Created by Rossi Riccardo on 16/05/2020.
//  Copyright © 2020 Riccardo Rossi. All rights reserved.
//

import UIKit

protocol StringValidator {
    func validate(string: String) -> Bool
}

class LoginViewController: UIViewController {
    let pinTextField: UITextView = UITextView()
    var pinValidator: StringValidator?
    
    func set(pinValidator: StringValidator) {
        self.pinValidator = pinValidator
    }
    
    //Bad
    func loginButtonContinueTapped_Bad() {
        if !pinTextField.text.isEmpty &&
            pinTextField.text.count == 5 &&
            pinTextField.text != "00000"
        {
            //Pin is valid
        } else {
            //Pin is NOT valid
        }
    }
    
    func loginButtonContinueTapped_Good() {
        if pinValidator?.validate(string: pinTextField.text) ?? true {
            //Pin is valid
        } else {
            //Pin is NOT valid
        }
    }
}

class LoginCoordinator {
    private class PinValidator: StringValidator {
        func validate(string: String) -> Bool {
            return !string.isEmpty &&
                    string.count == 5 &&
                    string != "00000"
        }
    }
    
    func start(from viewController: UIViewController) {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginViewController.set(pinValidator: PinValidator())
        viewController.present(loginViewController, animated: true)
    }
}
