//
//  Juegos.swift
//  Tli App
//
//  Created by Hugo Luna on 1/17/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import UIKit
import XLPagerTabStrip

@IBDesignable
class Juegos: UIViewController, IndicatorInfoProvider {
    
    @IBInspectable var cornerRadius: CGFloat = 4
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    
    @IBOutlet weak var cardHistoria: UIView!
    @IBOutlet weak var cardQuiz: UIView!
    @IBOutlet weak var cardAhorcado: UIView!
    @IBOutlet weak var cardPalabras: UIView!
    @IBOutlet weak var cardAdivina: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initCards()
        
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "JUEGOS")
    }
    
    
    
    
    
    func initCards(){
        
        cardHistoria.layer.cornerRadius = cornerRadius
        cardQuiz.layer.cornerRadius = cornerRadius
        cardAhorcado.layer.cornerRadius = cornerRadius
        cardPalabras.layer.cornerRadius = cornerRadius
        cardAdivina.layer.cornerRadius = cornerRadius
        
        let shadowPath = UIBezierPath(roundedRect: cardHistoria.bounds, cornerRadius: cornerRadius)
        
        cardHistoria.layer.masksToBounds = false
        cardHistoria.layer.shadowColor = shadowColor?.cgColor
        cardHistoria.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        cardHistoria.layer.shadowOpacity = shadowOpacity
        cardHistoria.layer.shadowPath = shadowPath.cgPath
        
        
        cardQuiz.layer.masksToBounds = false
        cardQuiz.layer.shadowColor = shadowColor?.cgColor
        cardQuiz.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        cardQuiz.layer.shadowOpacity = shadowOpacity
        cardQuiz.layer.shadowPath = shadowPath.cgPath
        
        
        cardAhorcado.layer.masksToBounds = false
        cardAhorcado.layer.shadowColor = shadowColor?.cgColor
        cardAhorcado.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        cardAhorcado.layer.shadowOpacity = shadowOpacity
        cardAhorcado.layer.shadowPath = shadowPath.cgPath
        
        
        cardPalabras.layer.masksToBounds = false
        cardPalabras.layer.shadowColor = shadowColor?.cgColor
        cardPalabras.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        cardPalabras.layer.shadowOpacity = shadowOpacity
        cardPalabras.layer.shadowPath = shadowPath.cgPath
        
        
        cardAdivina.layer.masksToBounds = false
        cardAdivina.layer.shadowColor = shadowColor?.cgColor
        cardAdivina.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        cardAdivina.layer.shadowOpacity = shadowOpacity
        cardAdivina.layer.shadowPath = shadowPath.cgPath
        
        
    }
    
}
