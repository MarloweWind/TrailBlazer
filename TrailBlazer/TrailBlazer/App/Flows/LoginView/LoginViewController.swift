//
//  LoginViewController.swift
//  TrailBlazer
//
//  Created by Алексей Мальков on 24.02.2021.
//  Copyright © 2021 Alexey Malkov. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButton(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else {return}
        
        do {
            let realm = try Realm()
            let path = realm.objects(User.self).filter("login == %@", login)
            if path.isEmpty {
                self.showAlert("Incorrect username")
            } else {
                if path[0].password == password {
                    self.loginAction()
                } else {
                    self.showAlert("Incorrect password")
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else {return}
        
        do {
            let realm = try Realm()
            let path = realm.objects(User.self).filter("login == %@", login)
            realm.beginWrite()
            if path.isEmpty {
                let newUser = User()
                newUser.login = login
                newUser.password = password
                realm.add(newUser)
                self.loginAction()
            } else {
                path[0].password = password
                self.loginAction()
            }
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    private func loginAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MapViewController")
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: nil)
    }
    
    private func showAlert(_ text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
