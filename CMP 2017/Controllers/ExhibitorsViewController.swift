//
//  ExhibitorsViewController.swift
//  CMP 2017
//
//  Created by Leonardo Cid on 8/15/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import Foundation
import UIKit
import AERecord
import CoreData
import Kingfisher


class ExhibitorsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var exhibitorsArray: [CDExhibitor]?
    @IBOutlet var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExhibitors();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTitleBarItemsColor(color: UIColor.black)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadExhibitors() {
        let request = CDExhibitor.createFetchRequest()
        let results = AERecord.execute(fetchRequest: request)
        exhibitorsArray = results as? [CDExhibitor];
        self.tableView?.reloadData()
        
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exhibitorsArray != nil ? (exhibitorsArray?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExhibitorCell", for: indexPath) as! ExhibitorCell
        let exhibitor = exhibitorsArray![indexPath.row]
        cell.exhibitorName?.text = exhibitor.name! + " " + exhibitor.lastName!
        cell.exhibitorEducation?.text = exhibitor.degree!
        
        var url: URL
        if exhibitor.url!.starts(with: "http") {
            url = URL(string: exhibitor.url!)!
        } else {
            url = URL(string: WSHelper.getBaseURL() + exhibitor.url!)!
        }
        cell.exhibitorImageView?.kf.setImage(with: url)
        cell.exhibitorImageView?.layer.cornerRadius = 30
        cell.exhibitorImageView?.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exhibitorVC = self.storyboard?.instantiateViewController(withIdentifier: "Exhibitor") as! ExhibitorViewController
        let exhibitor = exhibitorsArray![indexPath.row]
        exhibitorVC.exhibitor = exhibitor
        exhibitorVC.title = "Exhibitor Profile"
        self.show(exhibitorVC, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
