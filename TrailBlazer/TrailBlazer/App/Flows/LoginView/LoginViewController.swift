//
//  LoginViewController.swift
//  TrailBlazer
//
//  Created by Алексей Мальков on 24.02.2021.
//  Copyright © 2021 Alexey Malkov. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    var router: BaseRouter!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router = BaseRouter(viewController: self)
        loginButtonOutlet?.isEnabled = false
        registerButtonOutlet?.isEnabled = false
        configureLogin()
    }
    
    func configureLogin() {
            Observable
                .combineLatest(
                    loginTextField.rx.text,
                    passwordTextField.rx.text
                )
                .map { login, password in
                    return !(login ?? "").isEmpty && (password ?? "").count >= 1
                }
                .bind { [weak loginButtonOutlet, weak registerButtonOutlet] inputFilled in
                    loginButtonOutlet?.isEnabled = inputFilled
                    registerButtonOutlet?.isEnabled = inputFilled
            }
        }

    @IBAction func loginButton(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else {return}
        
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
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        guard let login = loginTextField.text, let password = passwordTextField.text else {return}
        
        do {
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
        let destinationVC = storyboard.instantiateViewController(identifier: "MapViewController")
        router.push(vc: destinationVC)
    }
    
    private func showAlert(_ text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
