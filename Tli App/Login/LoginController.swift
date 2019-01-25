//
//  LoginController.swift
//  Tli App
//
//  Created by Hugo Luna on 1/24/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import MaterialTextField
import SCLAlertView
import FirebaseDatabase



class LoginController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var correoField: MFTextField!
    
    @IBOutlet weak var passField: MFTextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.correoField.delegate = self
        self.passField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            
            goToHome()
            
            
        }else{
            
            
            
            
        }
    }
    
    
    

    
    
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        login(email: correoField.text!, password: passField.text!)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
     func login(email: String, password: String) {
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if(error != nil){
                
                print(error.debugDescription)
                
                
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    let appearanceError = SCLAlertView.SCLAppearance(
                        showCloseButton: true
                        
                    )
                    switch errCode {
                        
                    case .wrongPassword:
                        SCLAlertView(appearance: appearanceError).showError("Upps", subTitle: "Ocurrio el siguiente error:  La direccion de correo electronico o contraseña son invalidos", closeButtonTitle: nil, timeout: nil, colorStyle: 0xCC2E3A, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
                        
                    case .invalidEmail:
                        SCLAlertView(appearance: appearanceError).showError("Upps", subTitle: "Ocurrio el siguiente error:  La direccion de correo electronico es invalida", closeButtonTitle: nil, timeout: nil, colorStyle: 0xCC2E3A, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
                        print("invalid email")
                    case .emailAlreadyInUse:
                        print("in use")
                        SCLAlertView(appearance: appearanceError).showError("Upps", subTitle: "Ocurrio el siguiente error:  La direccion de correo electronico está en uso", closeButtonTitle: nil, timeout: nil, colorStyle: 0xCC2E3A, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
                    default:
                        print("Create User Error: \(error!)")
                        SCLAlertView(appearance: appearanceError).showError("Upps", subTitle: "Ocurrio un error", closeButtonTitle: nil, timeout: nil, colorStyle: 0xCC2E3A, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
                    }
                }
                
                
                
                
                
                
            }else{
                
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
                
                
                SCLAlertView(appearance: appearance2).showSuccess("Hola", subTitle: "¡Bienvenido de nuevo!", closeButtonTitle: nil, timeout: nil, colorStyle: 0x2ECC71, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
                
                
                
                self.goToHome()
                
              
            }
            
            
        }
        
        
        
        
        print("Login with: email =\(email) password = \(password)")
    }

    
    
    
    func goToHome(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let miVistaDos = storyBoard.instantiateViewController(withIdentifier: "mainView") as! UINavigationController
        
        self.present(miVistaDos, animated:true, completion:nil)
        
    }
    
    
    
    
    /*
     * Escucha de click en la pantalla
     * para cerrar el teclado
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            // ...
            self.correoField.resignFirstResponder()
            self.passField.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Hello")
        
        if(textField == correoField){
            print("Doo")
            textField.resignFirstResponder()
            passField.becomeFirstResponder()
        }else if(textField == passField){
            textField.resignFirstResponder()
        }
        
        
        
        
        
        return true
    }
    
    

   
    
    
    
}
