//
//  Comunidad.swift
//  Tli App
//
//  Created by Hugo Luna on 1/17/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class Comunidad: UIViewController, IndicatorInfoProvider {

    
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "COMUNIDAD")
    }
    
    
}
