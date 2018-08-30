//
//  RegistryViewController.swift
//  CMP 2017
//
//  Created by Rodolfo Casanova on 6/23/18.
//  Copyright © 2018 Rodolfo Casanova. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    // MARK: - Vars -
    let menuImages : [String] = ["ic_menu_exp","ic_menu_event","ic_menu_net","ic_menu_tran","ic_menu_loc","ic_menu_noti","ic_menu_conf"]
    let menuStrings : [String] = ["Exhibitors","Events","Networking","Transportation","Map","Notifications","Profile"]
    
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
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var centerViewController : UIViewController!
        let currentCenter = self.sideMenuController?.centerViewController
        switch(indexPath.row) {
        case 0:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "exhibitors")
            if centerViewController == nil {
                centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Exhibitors")
                centerViewController.title = "Exhibitors"
                let navController = UINavigationController(rootViewController: centerViewController)
                navController.navigationBar.setBarColor(UIColor.clear)
                sideMenuController?.embed(centerViewController: navController, cacheIdentifier: "exhibitors")
            } else if centerViewController  != currentCenter {
                sideMenuController?.embed(centerViewController: centerViewController)
            }
            break
        case 1:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "events")
            if centerViewController  != currentCenter {
                self.sideMenuController?.embed(centerViewController: centerViewController)
            }
            break
        case 2:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "networking")
            if centerViewController == nil {
                centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Networking")
                centerViewController.title = "NETWORKING"
                let navController = UINavigationController(rootViewController: centerViewController)
                navController.navigationBar.setBarColor(UIColor.clear)
                sideMenuController?.embed(centerViewController: navController, cacheIdentifier: "networking")
            } else if centerViewController  != currentCenter {
                sideMenuController?.embed(centerViewController: centerViewController)
            }
            break
        case 3:
            
            break
        case 4:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "map")
            if centerViewController == nil {
                centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Map")
                centerViewController.title = "MAP"
                let navController = UINavigationController(rootViewController: centerViewController)
                navController.navigationBar.setBarColor(UIColor.clear)
                sideMenuController?.embed(centerViewController: navController, cacheIdentifier: "map")
            } else if centerViewController  != currentCenter {
                sideMenuController?.embed(centerViewController: centerViewController)
            }
            
            break
        case 5:
            
            break
        case 6:
            centerViewController = self.sideMenuController?.viewController(forCacheIdentifier: "profile")
            if centerViewController == nil {
                centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "Profile")
                centerViewController.title = "Profile"
                sideMenuController?.embed(centerViewController: centerViewController, cacheIdentifier: "profile")
            } else if centerViewController  != currentCenter {
                sideMenuController?.embed(centerViewController: centerViewController)
            }
            break
        default:
            
            break
        }
        self.sideMenuController?.toggle()
    }
}
