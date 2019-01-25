//
//  SignUpController.swift
//  Tli App
//
//  Created by Hugo Luna on 1/24/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MaterialTextField
import SCLAlertView


class SignUpController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var nameField: MFTextField!
    @IBOutlet weak var cityField: MFTextField!
    @IBOutlet weak var correoField: MFTextField!
    @IBOutlet weak var phoneField: MFTextField!
    @IBOutlet weak var passField: MFTextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nameField.delegate = self
        cityField.delegate = self
        correoField.delegate = self
        phoneField.delegate = self
        passField.delegate = self
        

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        
        let name: String
        let city: String
        let correo: String
        let phone: String
        let pass: String
        
        
        name = nameField.text!
        city = cityField.text!
        correo = correoField.text!
        phone = phoneField.text!
        pass = passField.text!
        
        signup(name: name, city: city, email: correo, phone: phone, password: pass)
        
        
        
    }
    
    
    
    func signup(name: String, city: String , email: String, phone: String, password: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        //print("Signup with: name = \(name) email =\(email) password = \(password)")
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if(error != nil){
                
                let appearanceError = SCLAlertView.SCLAppearance(
                    showCloseButton: true
                    
                )
                
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .invalidEmail:
                        SCLAlertView(appearance: appearanceError).showError("Upps", subTitle: "Ocurrio el siguiente error:  La direccion de correo electronico es invalida", closeButtonTitle: nil, timeout: nil, colorStyle: 0xCC2E3A, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
                        print("invalid email")
                    case .emailAlreadyInUse:
                        print("in use")
                        SCLAlertView(appearance: appearanceError).showError("Upps", subTitle: "Ocurrio el siguiente error:  La direccion de correo electronico está en uso", closeButtonTitle: nil, timeout: nil, colorStyle: 0xCC2E3A, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
                
                print(error.debugDescription)
                
                
            }else{
                
                
                
                
                let data = [
                    "name": name,
                    "city": city,
                    "mobile": phone,
                    "photo": "default",
                    "thumb_photo": "default",
                    "device_token": "iphone",
                    "verified": "0",
                    
                ];
                
                ref.child("Users").child((user?.user.uid)!).setValue(data)
                
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) {idToken, error in
                    if error != nil {
                        // Handle error
                        return;
                    }
                    
                    var mData: DatabaseReference!
                    
                    mData = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
                    mData.child("device_token").setValue(idToken)
                }
                
                let appearance2 = SCLAlertView.SCLAppearance(
                    showCloseButton: true
                    
                )
                
                
                SCLAlertView(appearance: appearance2).showSuccess("Felicidades", subTitle: "¡Creaste tu cuenta correctamente!", closeButtonTitle: nil, timeout: nil, colorStyle: 0x2ECC71, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
                
                self.goToHome()
               
            }
        }
        
        
        
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            // ...
            self.nameField.resignFirstResponder()
            self.cityField.resignFirstResponder()
            self.correoField.resignFirstResponder()
            self.phoneField.resignFirstResponder()
            self.passField.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == nameField){
            
            textField.resignFirstResponder()
            cityField.becomeFirstResponder()
        }else if(textField == cityField){
            textField.resignFirstResponder()
            correoField.becomeFirstResponder()
        }else if(textField == correoField){
            textField.resignFirstResponder()
            phoneField.becomeFirstResponder()
        }else if(textField == phoneField){
            textField.resignFirstResponder()
            passField.becomeFirstResponder()
        }else if(textField == passField){
            textField.resignFirstResponder()

        }
        
        
        
        
        
        return true
    }
    
    
    
    
    
    
    @IBAction func btnGoToLogin(_ sender: UIButton) {
        
        //navigationController?.popToRootViewController(animated: true)
        navigationController?.popViewController(animated: true)

        
    }
    
    
    func goToHome(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let miVistaDos = storyBoard.instantiateViewController(withIdentifier: "mainView") as! UINavigationController
        
        self.present(miVistaDos, animated:true, completion:nil)
        
    }
    
    
    
}
