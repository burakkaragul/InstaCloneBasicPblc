//
//  SettingsViewController.swift
//  InstaCloneFirebaseBsc
//
//  Created by Burak Karagül on 27.01.2022.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logoutClicked(_ sender: Any) {
        
//        Kullanıcı çıkış işlemini Firebase üzerinden de yapıyoruz.
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("error")
        }
        
        
    }
    
    

}
