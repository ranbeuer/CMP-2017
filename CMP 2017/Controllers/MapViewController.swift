//
//  MapViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 30/08/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    @IBOutlet var mapView: GMSMapView?
    // MARK: - Vars -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
