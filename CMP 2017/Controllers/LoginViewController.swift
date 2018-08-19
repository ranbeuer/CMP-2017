//
//  LoginViewController.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit
import FRHyperLabel

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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddEvent")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func showSignUp() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUp")
        self.show(vc!, sender: nil)
    }
    
}
