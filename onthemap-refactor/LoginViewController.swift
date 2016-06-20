//
//  LoginViewController.swift
//  onthemap-refactor
//
//  Created by Daniel Huang on 6/20/16.
//  Copyright © 2016 Daniel Huang. All rights reserved.
//

import UIKit

class LoginViewController: HelperViewController, UITextFieldDelegate {

   
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextfield.delegate = self
        loginButton.setTitle("Logging in...", forState: .Disabled)
        loginButton.setTitle("Login", forState: .Normal)
    } //end viewdidload
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func loginUser(sender: AnyObject) {
        setFormState(true)
        
        if let username = emailTextField.text, password = passwordTextfield.text {
            User.loginUser(username, password: password) { (success, errorMessage) in
                self.setFormState(false, errorMessage: errorMessage)
                if success {
                    self.setFormState(false)
                    self.performSegueWithIdentifier("showTabViews", sender: self)
                }
            }
        }
    } //end loginuser
    
    @IBAction func signupUser(sender: AnyObject) {
    
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    
    }//end sign up
    
    private func setFormState(loggingIn: Bool, errorMessage: String? = nil) {
        emailTextField.enabled = !loggingIn
        passwordTextfield.enabled = !loggingIn
        loginButton.enabled = !loggingIn
        if let message = errorMessage {
            showErrorAlert("Authentication Error", defaultMessage: message, errors: [])
        }
    }

    // MARK: - Keyboard methods
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:  #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
