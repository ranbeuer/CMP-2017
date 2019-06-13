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
import ObjectMapper

class MapViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet var mapView: GMSMapView?
    var hoteles: Array<Hotel>?
    // MARK: - Vars -
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.delegate = self
        loadHotelsFile()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addMarkers()
        
    }
    
    func loadHotelsFile() {
        if let path = Bundle.main.path(forResource: "Hoteles", ofType: "json")
        {
            do {
                let jsonString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                hoteles = Array<Hotel>(JSONString: jsonString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addMarkers() {
        
        
        
        for hotel in hoteles! {
            let position = hotel.coordinate?.cllcoordinate()
            let marker = GMSMarker(position: position!)
            marker.title = hotel.name!
            marker.snippet = hotel.snippet!
            marker.tracksViewChanges = true
            marker.map = mapView
        }
        
        let center = CLLocationCoordinate2D(latitude: 21.122767, longitude: -101.6709467)
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: center, zoom: 12))
    }
}
