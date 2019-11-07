//
//  ViewController.swift
//  ToDo-Firebase
//
//  Created by Алексей on 06/11/2019.
//  Copyright © 2019 Alexey Makarov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Advanced properties
    let segueIdentifier = "tasksSegue"
    
    // MARK: Outlets
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Поднимаем экран при вызове клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        warningLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    // MARK: Functions
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // Прибавляем высоту клавиатуры для пролистывания
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + kbFrameSize.height)
        
        // Высота для бокового скролла
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc func kbDidHide(notification: Notification) {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    // Функция анимации предупреждение выведется на 3 секунды
    func displayWarningLabel (withText text: String) {
        
        warningLabel.text = text
        
            UIView.animate(withDuration: 3,     // длительность
            delay: 0,                           // задержка
            usingSpringWithDamping: 1,          // интенсивность анимации
            initialSpringVelocity: 1,           // интенсивность анимации
            options: .curveEaseInOut,           // Какая анимация можно перечилсить несколько через [.curveEaseInOut, .curveEaseInOut]
            animations: { [weak self] in
                self?.warningLabel.alpha = 1    // Что у будет происходить
        }) { [weak self] complete in
            self?.warningLabel.alpha = 0        // Что произойдет по завершению
        }
    
    }
    
    // MARK: Actions
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil { // Проверка на ошибку
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil { // Проверка что пользователь не пустой
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
                return
            }
            
            self?.displayWarningLabel(withText: "No such user")
        }
         
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTF.text, let password = passwordTF.text, email != "", password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                if user != nil {
                   
                } else {
                    print("User is not created")
                }
            } else {
                print (error!.localizedDescription)
            }
        }
    }

}

