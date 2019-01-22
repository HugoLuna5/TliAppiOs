//
//  ViewController.swift
//  Ecomentes
//
//  Created by Hugo Luna on 09/12/17.
//  Copyright © 2017 Luna Inc. All rights reserved.
//

import UIKit
import ILLoginKit
import FirebaseAuth
class ViewController: UIViewController{

   
    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        if Auth.auth().currentUser != nil {
            
            goToHome()


        }else{
        loginCoordinator.start()
          
         
            
        }
    }
    
   
    func goToHome(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let miVistaDos = storyBoard.instantiateViewController(withIdentifier: "container") as! TabBarControllerViewController
        
        self.present(miVistaDos, animated:true, completion:nil)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

