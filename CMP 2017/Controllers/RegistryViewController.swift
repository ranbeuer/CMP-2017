//
//  RegistryViewController.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class RegistryViewController: UIViewController {

    // MARK: - Vars -
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var termsCheckButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.layer.cornerRadius = 5
        fullNameTextField.layer.borderWidth = 1
        fullNameTextField.layer.borderColor = UIColor.white.cgColor
        lastNameTextField.layer.cornerRadius = 5
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.cornerRadius = 5
        termsCheckButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signUpPressed(_ sender: Any) {
        if validateFields() {
            SVProgressHUD.show(withStatus: "Creando Usuario...")
            WSHelper.sharedInstance.createUser(email: emailTextField.text!, password: passwordTextField.text!, name: fullNameTextField.text!, lastName: lastNameTextField.text!) { (_ response:Any? , _ error: Error?) in
                if error == nil {
                    WSHelper.sharedInstance.login(email: self.emailTextField.text!, password: self.passwordTextField.text!, withResult: { (_ response:Any?, _ error: Error?) in
                        if (error == nil) {
                            SessionHelper.instance.saveSessionInfo(response as! NSDictionary)
                            self.showAddEventScreen()
                        } else {
                            SVProgressHUD.showError(withStatus: error?.localizedDescription)
                        }
                    })
                    
                } else {
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func checkPressed(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        signUpButton.isEnabled = sender.isSelected
    }
    
    func validateFields() -> Bool {
        if fullNameTextField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: "Please enter your first name.")
            return false
        } else if lastNameTextField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: "Please enter your last name.")
            return false
        } else if emailTextField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: "Please enter your email.")
            return false
        } else if !(emailTextField.text?.isValidMail())! {
            SVProgressHUD.showError(withStatus: "Please enter a valid email.")
            return false
        } else if passwordTextField.text?.count == 0 {
            SVProgressHUD.showError(withStatus: "Please enter a valid password.")
            return false
        } else {
            return true
        }
    }

    func showAddEventScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEvent")
        self.present(vc!, animated: true, completion: nil)
    }
}
