//
//  ExhibitorViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 8/14/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ExhibitorViewController : UIViewController {
    var exhibitor : CDExhibitor!
    @IBOutlet var exhibitorImageView : UIImageView!
    @IBOutlet var exhibitorName : UILabel!
    @IBOutlet var exhibitorView : UIView!
    @IBOutlet var exhibitorDescription : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitleBarItemsColor(color: UIColor.white)
        let gradient = CAGradientLayer()
        let rect = self.view.bounds
        gradient.frame = rect
        gradient.colors = [UIColor(rgb:0xF25A0D).cgColor, UIColor(rgb:0xfCC84A).cgColor]
        //        gradient.locations = [0, 0.6, 1]
        self.view.layer.insertSublayer(gradient, at: 0)
        
        exhibitorName?.text = exhibitor!.name! + " " + exhibitor!.lastName!
        exhibitorDescription.text = exhibitor!.degree! + "\n" + exhibitor!.job! + "\n" + exhibitor!.history! + "\n"
        
        var url: URL
        if exhibitor.url!.starts(with: "http") {
            url = URL(string: exhibitor.url!)!
        } else {
            url = URL(string: WSHelper.getBaseURL() + exhibitor.url!)!
        }
        exhibitorImageView?.kf.setImage(with: url)
        exhibitorView?.layer.cornerRadius = 20
        exhibitorView?.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
