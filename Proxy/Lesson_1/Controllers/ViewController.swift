//
//  ViewController.swift
//  Lesson_1
//
//  Created by Evgeny Kolesnik on 28.01.2020.
//  Copyright © 2020 Evgeny Kolesnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rootInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Жест нажатия
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
// MARK: - Hide\Show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        let info = notification.userInfo! as NSDictionary
        let size = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        let contentInsets = UIEdgeInsets(top: 0, left:0, bottom: size.height, right: 0)
        
        self.scrollView?.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: Notification){
        scrollView.contentInset = .zero
    }
    
    @objc func hideKeyboard(){
        self.scrollView.endEditing(true)
        
    }
    
// MARK: - Alert
    
    func showAuthError() {
        //формируем сам алерт
        let alertVC = UIAlertController(title: "Ошибка", message: "Не верный пароль или логин", preferredStyle: .alert)
        //формируем кнопку к алерту
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        //добавдяем кнопку к алерту
        alertVC.addAction(action)
        
        //выводим на экран
        present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Изменение функции перехода (логин + пасс)
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let login = loginTextField.text, let password = passTextField.text {
            print("Login \(login) and Password \(password)")
            
            if login == "admin", password == "admin" {
                print("Успешная авторизация")
                return true
            } else {
                print("Не успешная авторизация")
                //показываем ошибку
                showAuthError()
                return false
            }
        }
        //показываем ошибку
        showAuthError()
        return false
    }
}

