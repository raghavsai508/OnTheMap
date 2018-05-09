//
//  ViewController.swift
//  OnTheMap
//
//  Created by Raghav Sai Cheedalla on 5/1/18.
//  Copyright © 2018 Swift Enthusiast. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: Variables
    var keyboardOnScreen = false
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func btnLoginAction(_ sender: Any) {
        if txtEmail.text!.isEmpty || txtPassword.text!.isEmpty {
            showAlert(message: "Email or Password is missing", title: "")
        } else {
            showLoadingImage()
            let networkManager = NetworkManager.sharedInstance()
            _ = networkManager.loginWith(username: txtEmail.text!, password: txtPassword.text!) { (success, errorMessage) in
                DispatchQueue.main.async {
                    self.hideLoadingImage()
                    if success {
                        self.successfulLogin()
                    } else {
                        self.showAlert(message: errorMessage!, title: "")
                    }
                }
            }
        }
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        let url = URL(string: Constants.Udacity.AccountSignUpURL)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    //MARK: UI
    private func successfulLogin() {
        if let navigationController = storyboard?.instantiateViewController(withIdentifier: "OnTheMapTabbarNavigationController") as? UINavigationController {
            present(navigationController, animated: true, completion: nil)
        }
    }
}

// MARK: - LoginViewController: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func userDidTap(_ sender: Any) {
        resignIfFirstResponder(txtEmail)
        resignIfFirstResponder(txtPassword)
    }
    
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        scrollView.isScrollEnabled = true
        let keyboardHeightValue = keyboardHeight(notification)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeightValue, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = view.frame
        aRect.size.height -= keyboardHeightValue
        if let activeField = activeField {
            if (!aRect.contains(activeField.frame.origin)){
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let keyboardHeightValue = keyboardHeight(notification)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardHeightValue, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        view.endEditing(true)
        scrollView.isScrollEnabled = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

}


// MARK: - LoginViewController (Notifications)
private extension LoginViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
