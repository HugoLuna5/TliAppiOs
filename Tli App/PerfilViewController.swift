//
//  PerfilViewController.swift
//  Tli App
//
//  Created by Hugo Luna on 1/23/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Kingfisher

class PerfilViewController: UIViewController {

    
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        configureCIrcleImage()
        loadData()
    }
    
    
    func configureCIrcleImage(){
        
        photoUser.layer.borderWidth = 1
        photoUser.layer.masksToBounds = false
        photoUser.layer.borderColor = UIColor.white.cgColor
        photoUser.layer.cornerRadius = photoUser.frame.height/2
        photoUser.clipsToBounds = true
    }
    
    
    
    func loadData(){
        var mDatabase: DatabaseReference!
       
        
        mDatabase = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
        
        mDatabase.observe(DataEventType.value, with: { (snapshot) in
            let user = snapshot.value as? [String : AnyObject] ?? [:]
            
            self.nameLabel.text = (user["name"]  as! String)
            
            if user["photo"] as! String != "default" {
                
                let userPhoto = URL(string: user["photo"] as! String)
                self.photoUser.kf.setImage(with: userPhoto)
                
            }else{
                
                let urlPhoto = URL(string: "https://firebasestorage.googleapis.com/v0/b/ecomentes-1f3d7.appspot.com/o/default-user.png?alt=media&token=0ff53569-3354-466f-a5b8-3df07a56053f")
                
                
                self.photoUser.kf.setImage(with: urlPhoto)
            }
            
            
        })
        
        
        
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
                let miVistaDos = storyBoard.instantiateViewController(withIdentifier: "uiLoginMain") as! UINavigationController
                
                self.present(miVistaDos, animated:true, completion:nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
        }
        
        
        
    }
    
    
}
