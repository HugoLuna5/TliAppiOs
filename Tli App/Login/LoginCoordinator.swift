//
//  LoginCoordinator.swift
//  Tli App
//
//  Created by Hugo Luna on 1/24/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import Foundation
import ILLoginKit
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView
class LoginCoordinator: ILLoginKit.LoginCoordinator {
    
    // MARK: - LoginCoordinator
    
    //variables
    
    let accesViewController = ViewController().goToHome()
    
    
    
    
    override func start() {
        super.start()
        
        
        configureAppearance()
    }
    
    override func finish() {
        super.finish()
    }
    
    
    // MARK: - Setup
    
    // Customize LoginKit. All properties have defaults, only set the ones you want.
    func configureAppearance() {
        
        
        // Customize the look with background & logo images
        backgroundImage = UIImage(named: "fondo1.png")!
        
        
        //mainLogoImage = UIImage(named: "icondoo")!
        // secondaryLogoImage =
        
        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Iniciar sesión"
        signupButtonText = "Registrarte"
        facebookButtonText = "Bienvenido a Ecomentes"
        forgotPasswordButtonText = "¿Olvidaste tu Contraseña?"
        recoverPasswordButtonText = "Recuperar"
        namePlaceholder = "Nombre"
        usernamePlaceholder = "Nombre de usuario"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Contraseña!"
        repeatPasswordPlaceholder = "Confirmar contraseña!"
        
        
    }
    
    // MARK: - Completion Callbacks
    
    // Handle login via your API
    override func login(email: String, password: String) {
        
        
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
                currentUser?.getTokenForcingRefresh(true) {idToken, error in
                    if let error = error {
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
                
                
                
                
                self.accesViewController
                self.finish()
            }
            
            
        }
        
        
        
        
        print("Login with: email =\(email) password = \(password)")
    }
    
    // Handle signup via your API
    override func signup(name: String,username: String , email: String, password: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        print("Signup with: name = \(name) email =\(email) password = \(password)")
        
        
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
                    "username": username,
                    "city": "default",
                    "status": "=====",
                    "desc": "=====",
                    "image": "default",
                    "thumb_image": "default",
                    "device_token": "iphone",
                    "banner_image": "default",
                    "banner_thumb_image": "default",
                    "verified": "0",
                    "facebook": "default",
                    "twitter": "default"
                    
                ];
                
                ref.child("Users").child(user!.uid).setValue(data)
                
                let currentUser = Auth.auth().currentUser
                currentUser?.getTokenForcingRefresh(true) {idToken, error in
                    if let error = error {
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
                self.accesViewController
                self.finish()
            }
        }
        
        
        
        
        
        
    }
    
    // Handle Facebook login/signup via your API
    override func enterWithFacebook() {
        print("Login/Signup via Facebook with: FB profile ")
    }
    
    // Handle password recovery via your API
    override func recoverPassword(email: String) {
        print("Recover password with: email =\(email)")
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error.debugDescription != nil {
                print(error.debugDescription)
            }
            
            let appearance2 = SCLAlertView.SCLAppearance(
                showCloseButton: true
                
            )
            
            
            SCLAlertView(appearance: appearance2).showSuccess("Felicidades", subTitle: "¡Se ha enviado un correo de recuperación de contraseña a esta dirección \(email)!", closeButtonTitle: nil, timeout: nil, colorStyle: 0x2ECC71, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: SCLAnimationStyle.topToBottom)
            
            
        }
        
    }
    
}

