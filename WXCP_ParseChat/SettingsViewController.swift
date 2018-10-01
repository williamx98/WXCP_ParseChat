//
//  SettingsViewController.swift
//  WXCP_ParseChat
//
//  Created by Will Xu  on 9/30/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import Parse
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        PFUser.logOutInBackground(block: {
            error in print("here")
        })
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
