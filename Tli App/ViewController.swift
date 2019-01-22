//
//  ViewController.swift
//  Tli App
//
//  Created by Hugo Luna on 11/8/18.
//  Copyright © 2018 Luna Inc. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var displayPalabra: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var palabra: UITextField!
    
    var databaseRef: DatabaseReference!
    var pickerData: [String] = [String]()
    var lengua: String = "nahuatl"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.picker.delegate = self
        self.picker.dataSource = self
        self.databaseRef = Database.database().reference()
        pickerData = ["Nahuatl", "Tenek"]
        
        
        
        
        
        
        
    }

    @IBAction func btnTranslate(_ sender: UIButton) {
        
        
        self.databaseRef.child(lengua).queryOrdered(byChild: "significado").queryStarting(atValue:  self.palabra.text).queryEnding(atValue:  self.palabra.text).observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                
                let desc = dict["significado"] as! String
                
                self.displayPalabra.text = desc
                
            }
            
            
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
  
 
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count

    }
    
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            lengua = "teneck"
        
    }
    
    
    
}

