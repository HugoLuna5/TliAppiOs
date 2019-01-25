//
//  PerfilViewController.swift
//  Tli App
//
//  Created by Hugo Luna on 1/23/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
class PerfilViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func btnCloseSession(_ sender: Any) {
        
        
        if(Auth.auth().currentUser != nil){
            
            do {
                //try mAuth.signOut()
                try Auth.auth().signOut()
                
                
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let miVistaDos = storyBoard.instantiateViewController(withIdentifier: "loginController") as! LoginController
                
                self.present(miVistaDos, animated:true, completion:nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
        }
        
        
        
    }
    
    
}
