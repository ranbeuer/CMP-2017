//
//  UIViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 8/3/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit

extension String{
    func isValidMail() -> Bool {
        let stricterFilter = false
        let stricterFilterString = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$"
        let laxString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailRegex = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex);
        return emailTest.evaluate(with:self)
    }
}
