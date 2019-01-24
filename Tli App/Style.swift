//
//  Style.swift
//  Tli App
//
//  Created by Hugo Luna on 1/23/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import UIKit

enum SpeechStatus {
    case ready
    case recognizing
    case unavailable
}

// MARK: - UI Styling

extension Traductor {
    
    func applyStyle() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.8034699559, blue: 0.789139688, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setUI(status: SpeechStatus) {
        switch status {
        case .ready: break
            //microphoneButton.setImage(#imageLiteral(resourceName: "available"), for: .normal)
        case .recognizing: break
           // microphoneButton.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
        case .unavailable: break
            //microphoneButton.setImage(#imageLiteral(resourceName: "unavailable"), for: .normal)
        }
    }
    
  
}

// MARK: - UITableViewDataSource

