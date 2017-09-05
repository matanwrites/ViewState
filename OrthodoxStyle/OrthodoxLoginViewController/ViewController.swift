//
//  ViewController.swift
//  OrthodoxLoginViewController
//
//  Created by sintaiyuan on 9/4/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loadingView: UIView!
    
    let loginInteractor = LoginInteractor()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor(red:1.00, green:0.52, blue:0.11, alpha:1.0)
        
        if loginInteractor.validate(email: emailTF.text, password: passwordTF.text) {
            loginButton.alpha = 1
            loginButton.isEnabled = true
        } else {
            loginButton.alpha = 0.2
            loginButton.isEnabled = false
        }
    }
    
    @IBAction func textDidChange(_ sender: Any) {
       let isValid = loginInteractor.validate(email: emailTF.text, password: passwordTF.text)
        
        if isValid {
            validState()
        } else {
           invalidState()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        loadingView.alpha = 0.4
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        loginInteractor.loginUser(email: emailTF.text!, password: passwordTF.text!) {
            self.loadingView.alpha = 0
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if $0 == true {
                self.validState()
                self.loginButton.alpha = 1
                self.loginButton.isEnabled = false
                self.loginButton.setTitle("Welcome!", for: .disabled)
                self.present(FakeAfterLoginController(), animated: true, completion: nil)
                
            } else {
                self.invalidState()
            }
        }
    }
    
    func validState() {
        view.backgroundColor = UIColor(colorLiteralRed: 133/255.0, green: 221/255.0, blue: 169/255.0, alpha: 1)
        loginButton.alpha = 1
        loginButton.isEnabled = true
    }
    
    func invalidState() {
        view.backgroundColor = UIColor(colorLiteralRed: 1, green: 23/255.0, blue: 106/255.0, alpha: 1)
        loginButton.alpha = 0.2
        loginButton.isEnabled = false
        self.loginButton.setTitle("Login", for: .disabled)
        emailTF.becomeFirstResponder()
    }
}





class LoginInteractor {
    func loginUser(email: String, password: String, complete: @escaping (Bool)->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            //lets say our fake network call do not like login with z
            let success = !email.contains("z")
            complete(success)
        })
    }
    
    func validate(email: String?, password: String?) -> Bool {
            guard let id = email, let pwd = password else {
                return false
            }
            
        return !(id.isEmpty || pwd.isEmpty)
    }
}



class FakeAfterLoginController : UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("logout")
        dismiss(animated: true, completion: nil)
    }
}
