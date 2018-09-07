//
//  RegistryViewController.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum MenuEntry : Int {
        case Exhibitors = 0
        case Events = 1
        case Networking = 2
        case Transportation = 3
        case Map = 4
        case Notifications = 5
        case Profile = 6
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    // MARK: - Vars -
    let menuImages : [String] = ["ic_menu_exp","ic_menu_event","ic_menu_net","ic_menu_tran","ic_menu_loc","ic_menu_noti","ic_menu_conf"]
    let menuStrings : [String] = [NSLocalizedString("Exhibitors", comment: ""),
                                  NSLocalizedString("Events", comment: ""),
                                  NSLocalizedString("Networking", comment: ""),
                                  NSLocalizedString("Transportation", comment: ""),
                                  NSLocalizedString("Map", comment: ""),
                                  NSLocalizedString("Notifications", comment: ""),
                                  NSLocalizedString("Profile", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = SessionHelper.instance.user
        nameLabel.text = (user?.firstName)! + " " + (user?.lastName)!
        var url: URL
        if (user?.avatarImg)!.starts(with: "http") {
            url = URL(string: (user?.avatarImg)!)!
        } else {
            url = URL(string: WSHelper.getBaseURL() + (user?.avatarImg)!)!
        }
        avatarImageView.kf.setImage(with: url)
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.clipsToBounds = true
        

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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        let label = cell.viewWithTag(2) as! UILabel
        let imageView = cell.viewWithTag(1) as! UIImageView
        label.text = menuStrings[indexPath.row]
        imageView.image = UIImage(named: menuImages[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let menuEntry = MenuEntry(rawValue: indexPath.row)
        if menuEntry == .Notifications || menuEntry == .Transportation {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var centerViewController : UIViewController!
        let currentCenter = self.sideMenuController?.centerViewController
        let menuEntry = MenuEntry(rawValue: indexPath.row)
        switch(menuEntry!) {
        case .Exhibitors:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "exhibitors")
            if centerViewController == nil {
                centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Exhibitors")
                centerViewController.title = NSLocalizedString("Exhibitors", comment: "").uppercased()
                let navController = UINavigationController(rootViewController: centerViewController)
                navController.navigationBar.setBarColor(UIColor.clear)
                sideMenuController?.embed(centerViewController: navController, cacheIdentifier: "exhibitors")
            } else if centerViewController  != currentCenter {
                sideMenuController?.embed(centerViewController: centerViewController)
            }
            break
        case .Events:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "events")
            if centerViewController  != currentCenter {
                self.sideMenuController?.embed(centerViewController: centerViewController)
            }
            break
        case .Networking:
            
            if !(currentCenter?.isKind(of: ContactsViewController.self))! {
                centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Networking")
                centerViewController.title = NSLocalizedString("Networking", comment: "").uppercased()
                let navController = UINavigationController(rootViewController: centerViewController)
                navController.navigationBar.setBarColor(UIColor.clear)
                sideMenuController?.embed(centerViewController: navController)
            }
            break
        case .Transportation:
            
            break
        case .Map:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "map")
            if centerViewController == nil {
                centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Map")
                centerViewController.title = NSLocalizedString("Map", comment: "").uppercased()
                let navController = UINavigationController(rootViewController: centerViewController)
                navController.navigationBar.setBarColor(UIColor.clear)
                sideMenuController?.embed(centerViewController: navController, cacheIdentifier: "map")
            } else if centerViewController  != currentCenter {
                sideMenuController?.embed(centerViewController: centerViewController)
            }
            
            break
        case .Notifications:
            
            break
        case .Profile:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "profile")
            if centerViewController == nil {
                centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Profile")
                centerViewController.title = NSLocalizedString("Profile", comment: "").uppercased()
                sideMenuController?.embed(centerViewController: centerViewController, cacheIdentifier: "profile")
            } else if centerViewController  != currentCenter {
                sideMenuController?.embed(centerViewController: centerViewController)
            }
            break
        }
        self.sideMenuController?.toggle()
    }
    
}
