//
//  ViewController.swift
//  ToDo-Firebase
//
//  Created by Алексей on 06/11/2019.
//  Copyright © 2019 Alexey Makarov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Advanced properties
    // Градиенты
    var gradientLayer: CAGradientLayer! {
        didSet {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Точка начала градиента
            gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Точка где заканчивается градиент
            let firstColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1) .cgColor
            let secondColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1) .cgColor
            gradientLayer.colors = [firstColor, secondColor] // Добавление цветов
            gradientLayer.locations = [0.5, 0.5,] //сколько занимает места каждый цвет
        }
    }
    var gradientLayerTwo: CAGradientLayer! {
        didSet {
            gradientLayerTwo.startPoint = CGPoint(x: 1, y: 0) // Точка начала градиента
            gradientLayerTwo.endPoint = CGPoint(x: 0, y: 1) // Точка где заканчивается градиент
            let firstColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5) .cgColor
            let secondColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5044413527) .cgColor
            gradientLayerTwo.colors = [firstColor, secondColor] // Добавление цветов
            gradientLayerTwo.locations = [0.5, 0.5,] //сколько занимает места каждый цвет
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    // Срабатывает когда меняется рамка view
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        
        gradientLayerTwo.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Добавили градиент на view
        gradientLayer = CAGradientLayer()
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Добавили второй градиент на view
        gradientLayerTwo = CAGradientLayer()
        view.layer.insertSublayer(gradientLayerTwo, at: 1)
    }
    
    // MARK: Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        
    }
    
}

