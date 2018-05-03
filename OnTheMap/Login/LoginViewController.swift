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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func btnLoginAction(_ sender: Any) {
        if txtEmail.text!.isEmpty || txtPassword.text!.isEmpty {
            showAlert(withMessage: "Email or Password is missing")
        } else {
            let networkManager = NetworkManager.sharedInstance()
            networkManager.loginWith(username: txtEmail.text!, password: txtPassword.text!) { (success, errorMessage) in
                DispatchQueue.main.async {
                    if success {
                        self.successfulLogin()
                    } else {
                        self.showAlert(withMessage: errorMessage!)
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
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    //MARK: Utility methods
    private func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
  

}

// MARK: - LoginViewController: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate methods
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
    


}

