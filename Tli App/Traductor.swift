//
//  Traductor.swift
//  Tli App
//
//  Created by Hugo Luna on 1/17/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import TwicketSegmentedControl
import McPicker
import FirebaseDatabase
import Speech
import InstantSearchVoiceOverlay
import TesseractOCR


class Traductor: UIViewController, IndicatorInfoProvider, UITextViewDelegate, UINavigationControllerDelegate,
    G8TesseractDelegate {
    
    
    var mWordDatabase: DatabaseReference!

    
    @IBOutlet weak var containerOptions: UIView!
    
    @IBOutlet weak var containerSelectLan: UIView!
    
    @IBOutlet weak var firstOption: UIButton!
    @IBOutlet weak var secondOption: UIButton!
    
    @IBOutlet weak var changeOptions: UIButton!
    
    @IBOutlet weak var btnTranslate: UIButton!
    
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var result: UITextView!
    let operationQueue = OperationQueue()
    
   

    let voiceOverlayController = VoiceOverlayController()

   
    let tesseract:G8Tesseract = G8Tesseract(language: "eng")!

    
    
    let data1: [[String]] = [["Español"]]
    let data: [[String]] = [["Nahuatl", "Tenek"]]
    
    var lengua: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = ["Texto", "Imagen", "Voz"]
        let frame = CGRect(x: 5, y: containerOptions.frame.height / 2 + 4, width: view.frame.width - 10, height: 40)
        
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        segmentedControl.backgroundColor = UIColor(red: 1/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0)
   
       
        containerOptions.addSubview(segmentedControl)
        self.firstOption.setTitle("Español", for: .normal)
        self.secondOption.setTitle("Nahuatl", for: .normal)
        lengua = "Nahuatl"
        
       
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        content.layer.borderWidth = 1
        content.layer.borderColor = borderColor.cgColor
        content.layer.cornerRadius = 5.0
        
        
        mWordDatabase = Database.database().reference(withPath: "Lenguas")
        self.content.delegate = self
        
        
        
        
        voiceOverlayController.settings.layout.inputScreen.titleListening = "Escuchando..."
        voiceOverlayController.settings.layout.inputScreen.subtitleBulletList = ["Abuela", "Persona"]

        voiceOverlayController.settings.layout.inputScreen.subtitleInitial = "Di algo como:"

        voiceOverlayController.settings.layout.inputScreen.titleInProgress = "Se buscara la traducción para:"
        
        voiceOverlayController.delegate = self
        
        // If you want to start recording as soon as modal view pops up, change to true
        voiceOverlayController.settings.autoStart = true
        voiceOverlayController.settings.autoStop = true
        voiceOverlayController.settings.showResultScreen = false


        tesseract.delegate = self
        tesseract.charWhitelist = "!@#$%^&*()_+=-qwertyuiop[]}{POIUYTREWQasdASDfghFGHjklJKLl;L:'\"\\|~`xcvXCVbnmBNM,./<>?";

       
    }
    
  
    

    
   
   
    
    @IBAction func firstOptionAction(_ sender: UIButton) {
        
        McPicker.showAsPopover(data:data1, fromViewController: self, sourceView: sender, doneHandler: { [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self?.firstOption.setTitle(name, for: .normal)
            }
            }, cancelHandler: { () -> Void in
                print("Canceled Popover")
        }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
            let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
            print("Component \(componentThatChanged) changed value to \(newSelection)")
        })
        
    }
    
    
    @IBAction func secondOptionAction(_ sender: UIButton) {
        
        McPicker.showAsPopover(data:data, fromViewController: self, sourceView: sender, doneHandler: { [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self?.secondOption.setTitle(name, for: .normal)
                self?.lengua = name
            }
            }, cancelHandler: { () -> Void in
                print("Canceled Popover")
        }, selectionChangedHandler: { (selections: [Int:String], componentThatChanged: Int) -> Void  in
            let newSelection = selections[componentThatChanged] ?? "Failed to get new selection!"
            print("Component \(componentThatChanged) changed value to \(newSelection)")
        })
        
        
    }
    
    
    @IBAction func changeOptionsAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Upss", message: "Esta funcón aún no está disponible.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "TRADUCTOR")
    }
    
    
   
    
    @IBAction func btnTranslateAction(_ sender: UIButton) {
        let contentText: String
        
        contentText = content.text
        
        if(contentText != ""){
            connectDBTranslate(texto: contentText.lowercased(), lengua: self.lengua.lowercased())
        }else{
            let alert = UIAlertController(title: "Upss", message: "Debes ingresar una palabra para continuar.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    
    func connectDBTranslate(texto: String, lengua: String){
      let palabras =  self.mWordDatabase.child(lengua).queryOrdered(byChild: "significado").queryStarting(atValue: texto).queryEnding(atValue: texto).queryLimited(toLast: 100)
        
        
        palabras.observe(.childAdded) { (snapshot: DataSnapshot) in
            
            if(!snapshot.exists()){
                self.result.text = "No existe la palabra en nuestros registros..."

            }
            
            if let dict = snapshot.value as? [String: Any] {
                
                let pal: String = dict["palabra"] as! String
                
                
               
                self.result.text = pal
             
            }
        }
    }
    
    
    
    /*
    * Escucha de click en la pantalla
    * para cerrar el teclado
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            // ...
            self.content.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }
    
    
   

   
}



extension Traductor: TwicketSegmentedControlDelegate, VoiceOverlayDelegate {
    

    
    func didSelect(_ segmentIndex: Int) {
        print("Selected index: \(segmentIndex)")
        
        switch segmentIndex {
        case 0://opcion por texto
            break
        case 1://opcion por imagen
            
            presentImagePicker()
            break
        case 2://opcion por voz
            
            /*
            * Ajustes para trabjar con Speech Recognition
            */
           
          
            buttonTapped()
            
           

            
            
            
            break
        default:
            //opcion por default (texto)
            break
        }
        
        
        
    }
    
    
 
    
    func buttonTapped() {
        // First way to listen to recording through callbacks
        voiceOverlayController.start(on: self, textHandler: { (text, final, extraInfo) in
            print("callback: getting \(String(describing: text))")
            print("callback: is it final? \(String(describing: final))")
            
            if final {
               
            }
        }, errorHandler: { (error) in
            print("callback: error \(String(describing: error))")
        }, resultScreenHandler: { (text) in
            print("Result Screen: \(text)")
        }
        )
    }
    
    
    
    
    // Second way to listen to recording through delegate
    func recording(text: String?, final: Bool?, error: Error?) {
        if let error = error {
            print("delegate: error \(error)")
        }
        
        if error == nil {
            content.text = text
            
            btnTranslate.sendActions(for: .touchUpInside)

        }
    }
    
    
    
    /*
 
     // Tesseract Image Recognition
     func performImageRecognition(_ image: UIImage) {
     
     if let tesseract = G8Tesseract(language: "spa") {
     tesseract.engineMode = .tesseractCubeCombined
     tesseract.pageSegmentationMode = .auto
     tesseract.image = image.g8_blackAndWhite()
     tesseract.recognize()
     //textView.text = tesseract.recognizedText
     print(tesseract.recognizedText)
     }
     }
        */
    
    func performImageRecognition(_ image: UIImage){
        
        tesseract.image = image
        tesseract.recognize()
        //print("The 1 text is \(tesseract.recognizedText!)")
        
        let texto:String = tesseract.recognizedText!
        
        content.text = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        
        btnTranslate.sendActions(for: .touchUpInside)
        
    }
    
    
    
}





extension Traductor: UIImagePickerControllerDelegate {
    
    func presentImagePicker() {
        // 2
        let imagePickerActionSheet = UIAlertController(title: "Tomar/Elegir imagen",
                                                       message: nil, preferredStyle: .actionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Tomar foto",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker, animated: true)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // Insert here
        
        let libraryButton = UIAlertAction(title: "Elegir una existente",
                                          style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .photoLibrary
                                            self.present(imagePicker, animated: true)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 2
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        // 3
        present(imagePickerActionSheet, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     
        if let selectedPhoto = info[.originalImage] as? UIImage,
            let scaledImage = selectedPhoto.scaleImage(640) {
            
            
            dismiss(animated: true, completion: {
                self.performImageRecognition(scaledImage)
            })
        }
        
        
        
        
        // Set photoImageView to display the selected image.
    }
    
  
    
    
    
}



// MARK: - UIImage extension
extension UIImage {
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
