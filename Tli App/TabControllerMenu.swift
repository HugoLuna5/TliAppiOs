//
//  TabControllerMenu.swift
//  Tli App
//
//  Created by Hugo Luna on 1/17/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import Foundation
import XLPagerTabStrip


class TabControllerMenu:ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var shadowView: UIView!
    
    
    let backgroundTab = UIColor(red: 1/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0)
    
    let colorSelectItem = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = backgroundTab
        settings.style.buttonBarItemBackgroundColor = backgroundTab
        settings.style.selectedBarBackgroundColor = colorSelectItem
        //rgb(1, 188, 212)
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Light", size:14) ?? UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor(red: 179/255.0, green: 235/255.0, blue: 242/255.0, alpha: 1.0)
            newCell?.label.textColor = .white
        }
        super.viewDidLoad()
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        
      
        
        return [Comunidad(), Traductor(), Juegos()]
    }
    
 
    
    
}
