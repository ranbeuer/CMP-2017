//
//  TransportationViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 04/09/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SVProgressHUD

class TransportationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var transportationCollectionView : UICollectionView?
    @IBOutlet weak var routesCollectionView : UICollectionView?
    @IBOutlet weak var scheduleTableView : UITableView?
    var selectedDay : Int = -1;
    var selectedRoute : Int = -1;
    var days : [String] = []
    var routes : [String:[Route]] = [:]
    var routesArray : [Route] = []
    var routesDetails : [Int: [RouteDetail]] = [:]
    var routesSchedulesArray : [RouteDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WSHelper.sharedInstance.getCalendar { (response, error) in
            if (error == nil) {
                let array = response as! [[String: Any]]
                let routes = Mapper<Route>().mapArray(JSONArray: array)
                for (_, route) in routes.enumerated() {
                    let day = route.dateKey()
                    if !self.days.contains(day) {
                        var rArray = [Route]()
                        rArray.append(route)
                        self.routes[day] = rArray
                        self.days.append(day)
                    } else {
                        if var arr = self.routes[day] {
                            arr.append(route)
                            self.routes[day] = arr
                        }
                    }
                }
                self.transportationCollectionView?.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        clearSelection()
    }
    
    func clearSelection() {
        self.selectedRoute = -1
        self.selectedDay = -1
        self.routesArray = []
        self.routesSchedulesArray = []
        self.transportationCollectionView?.reloadData()
        self.routesCollectionView?.reloadData()
        self.scheduleTableView?.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == transportationCollectionView {
            return self.days.count
        }
        if (selectedDay != -1) {
            return self.routesArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = collectionView == transportationCollectionView ? "DayCell" : "RouteCell"
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if (collectionView == transportationCollectionView) {
            let weekDayLabel = cell.viewWithTag(1) as! UILabel
            let dayLabel = cell.viewWithTag(2) as! UILabel
            let dayKey = self.days[indexPath.row]
            let texts = dayKey.split(separator: " ")
            weekDayLabel.text = String(texts[0])
            dayLabel.text = String(texts[1])
            dayLabel.layer.cornerRadius = 20
            dayLabel.clipsToBounds = true
            if (indexPath.row == self.selectedDay) {
                dayLabel.backgroundColor = UIColor(rgb: 0xf45409)
                dayLabel.textColor = UIColor.white
            } else {
                dayLabel.backgroundColor = UIColor.white
                dayLabel.textColor = UIColor.black
            }
        } else {
            let routeLabel = cell.viewWithTag(1) as! UILabel
            routeLabel.text = self.routesArray[indexPath.row].routeName
            if (self.selectedRoute == indexPath.row) {
                routeLabel.textColor = UIColor(rgb: 0xf45409)
            } else {
                routeLabel.textColor = UIColor.black
            }
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == transportationCollectionView) {
            let width = ( self.view.frame.size.width - 30 ) / 5
            let size = collectionView == transportationCollectionView ? CGSize(width: width,  height: 65) : CGSize(width: width,  height: 50)
            return size;
        }
        return CGSize(width: 60,  height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == transportationCollectionView {
            selectedRoute = -1
            selectedDay = indexPath.row
            self.routesSchedulesArray = []
            self.scheduleTableView?.reloadSections(IndexSet(integer:0), with: .left)
            collectionView.reloadData()
            self.routesArray = self.routes[self.days[selectedDay]]!
            self.routesCollectionView?.reloadSections(IndexSet(integer:0))
        } else {
            selectedRoute = indexPath.row
            let route = self.routesArray[selectedRoute];
            collectionView.reloadData()
            if let detailsArray = self.routesDetails[route.idRoute!] {
                self.routesSchedulesArray = detailsArray
                self.scheduleTableView?.reloadSections(IndexSet(integer:0), with: .left)
            } else {
                WSHelper.sharedInstance.getRouteDetail(route: route) { (result, error) in
                    if (error == nil) {
                        let array = result as! [[String: Any]]
                        let routes = Mapper<RouteDetail>().mapArray(JSONArray: array)
                        self.routesDetails[route.idRoute!] = routes
                        self.routesSchedulesArray = routes
                        self.scheduleTableView?.reloadSections(IndexSet(integer:0), with: .left)
                    } else{
                        SVProgressHUD.showError(withStatus: "No hay rutas para ese día")
                        self.routesSchedulesArray = []
                        self.scheduleTableView?.reloadSections(IndexSet(integer:0), with: .left)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routesSchedulesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! RouteScheduleCell
        let detail = self.routesSchedulesArray[indexPath.row]
        cell.routeDescription.text = detail.routeDescription
        let hours = detail.hourLabel?.split(separator: " ")
        cell.hourLabel.text = String(hours![0])
        cell.ampmLabel.text = String(hours![1])
        return cell
    }
}


