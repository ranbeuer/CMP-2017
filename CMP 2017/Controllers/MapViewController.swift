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

class MapViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet var mapView: GMSMapView?
    // MARK: - Vars -
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.delegate = self
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
    
    func addMarkers() {
        
        let locations = [CLLocationCoordinate2D(latitude: 16.7691764831543, longitude: -99.7744750976563),
                         CLLocationCoordinate2D(latitude: 16.7685408, longitude: -99.7742921),
                         CLLocationCoordinate2D(latitude: 16.7917321, longitude: -99.822544)]
        let titles = ["Resort Mundo Imperial", "Princess Mundo Imperial", "Pierre Mundo Imperial"]
        let subtitles = ["Riviera Diamante Acapulco", "Riviera Diamante Acapulco","Costera de las Palmas"]
        let snippets = ["Relájese y descanse en una lujosa habitación que captura la belleza de Acapulco con diseños y decoraciones de inspiración local. Los amplios espacios, el mobiliario sofisticado, las suaves camas y los baños exquisitos le ofrecen el santuario perfecto para descansar tras un día de sol y olas en Acapulco. Déjese llevar por la belleza de la costa mexicana, y disfrute de las hermosas vistas a la ciudad y al mar desde su balcón privado.",
            "Con vista a la playa Revolcadero, el Princess Mundo Imperial es un resort familiar en el que la diversión nunca termina. A cada segundo de su estadía, este resort frente al mar, nombrado como uno de los mejores 500 hoteles en el mundo, le ofrece aventuras y disfrute en una de las playas más hermosas de Acapulco.",
            "Asentado en un paraje frente al mar, con árboles de mango, limoneros y palmeras, Pierre Mundo Imperial es un refugio acogedor e íntimo en la elegante zona Diamante de Acapulco. El resort se construyó en la década de 1950 como casa de verano del magnate petrolero y filántropo J. Paul Getty. Su arquitectura mexicana, sus pilares de piedra y sus decorados de madera ofrecen una alternativa cálida y auténtica que lo harán olvidarse de los enormes y bulliciosos hoteles de Acapulco."]
        let addresses = ["BLVD. BARRA VIEJA NO. 3 COL. PLAN DE LOS AMATES CP. 39931 ACAPULCO DIAMANTE,GRO. MÉXICO.",
            "COSTERA DE LAS PALMAS S/N COLONIA GRANJAS DEL MARQUÉS CP. 39890 ACAPULCO, GUERRERO. MÉXICO","COSTERA DE LAS PALMAS S/N COLONIA GRANJAS DEL MARQUEZ,CP. 39890 ACAPULCO, GUERRERO. MÉXICO"]
        
        for index in 0..<titles.count {
            let position = locations[index]
            let marker = GMSMarker(position: position)
            marker.title = titles[index]
            marker.snippet = snippets[index]
            marker.tracksViewChanges = true
            marker.map = mapView
        }
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: locations[0], zoom: 12))
    }
}
