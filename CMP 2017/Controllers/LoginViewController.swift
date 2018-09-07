//
//  LoginViewController.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit
import FRHyperLabel
import Alamofire
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpLabel: FRHyperLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBarColor(UIColor.clear)
        
//        emailTextField.layer.cornerRadius = 25
//        passwordTextField.layer.cornerRadius = 25
        signInButton.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verifyForSignedIn()
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
    @IBAction func signInPressed(_ sender: Any) {
        if emailTextField.text?.count != 0 && passwordTextField.text?.count != 0 {
            if (emailTextField.text?.isValidMail())! {
                SVProgressHUD.show(withStatus: NSLocalizedString("DialogProgressLogin", comment: ""))
                WSHelper.sharedInstance.login(email: emailTextField.text!, password: passwordTextField.text!) { (_ response:Any?, _ error: Error?) in
                    SVProgressHUD.dismiss()
                    if error == nil {
                        SessionHelper.instance.saveSessionInfo(response as! NSDictionary)
                        self.showAddEventScreen()
                    } else {
                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    }
                }
            } else {
                SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorInvalidEmail", comment: ""))
            }
        } else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("DialogErrorNoEmailPass", comment: ""))
        }
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEvent")
//        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func showSignUp() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp")
        self.show(vc!, sender: nil)
    }
    
    func showAddEventScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEvent")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func verifyForSignedIn() {
        if SessionHelper.instance.sessionToken != nil { //has logged in before
            if (SessionHelper.instance.eventsDownloaded) {
                let sideMenu = SideMenuController()
                let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainSideMenu") as! SideMenuViewController
                let eventsViewController  = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! EventsDailyViewController
                eventsViewController.title = NSLocalizedString("Events", comment: "").uppercased()
                let navController = UINavigationController(rootViewController: eventsViewController)
                navController.navigationBar.setBarColor(UIColor.clear)
                sideMenu.embed(centerViewController: navController, cacheIdentifier: "events")
                sideMenu.embed(sideViewController: sideMenuViewController)
                self.present(sideMenu, animated: true, completion: nil)
            } else {
                showAddEventScreen()
            }
        }
    }
}
