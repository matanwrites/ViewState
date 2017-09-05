//
//  ViewController.swift
//  ViewStates
//
//  Created by sintaiyuan on 9/2/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import UIKit

protocol ViewStateManaging: class {
    var state: ViewController.ViewState { get set }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    
    let loginInteractor = LoginInteractor()
    
    var state: ViewState = .ready {
        didSet { render() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginInteractor.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        state = .initial
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        loginInteractor.loginUser(email: emailTF.text!, password: passwordTF.text!)
    }
    
    
    @IBAction func textDidChange(_ sender: UITextField) {
        loginInteractor.validate(email: emailTF.text, password: passwordTF.text)
    }
}



extension ViewController : ViewStateManaging {
    enum ViewState {
        case initial
        case ready
        case interacting
        case loading
        case valid
        case error
        case transitionning
    }
    
    func render() {
        switch state {
        case .initial:
            UIApplication.shared.endIgnoringInteractionEvents()
            if loginInteractor.isValid(email: emailTF.text, password: passwordTF.text) {
                loginButton.alpha = 1
                loginButton.isEnabled = true
            } else {
                loginButton.alpha = 0.2
                loginButton.isEnabled = false
            }
            loginButton.setTitle("Login", for: .disabled)
            view.backgroundColor = UIColor(red:1.00, green:0.52, blue:0.11, alpha:1.0)
        case .ready:
            print("ready")
            UIApplication.shared.endIgnoringInteractionEvents()
            loadingView.alpha = 0
        case .interacting:
            print("interacting")
            UIApplication.shared.beginIgnoringInteractionEvents()
        case .loading:
            print("loading")
            emailTF.resignFirstResponder()
            passwordTF.resignFirstResponder()
            UIApplication.shared.beginIgnoringInteractionEvents()
            loadingView.alpha = 0.4
        case .error:
            print("error")
            view.backgroundColor = UIColor(colorLiteralRed: 1, green: 23/255.0, blue: 106/255.0, alpha: 1)
            loginButton.alpha = 0.2
            loginButton.isEnabled = false
            loginButton.setTitle("Login", for: .disabled)
        case .valid:
            print("valid")
            view.backgroundColor = UIColor(colorLiteralRed: 133/255.0, green: 221/255.0, blue: 169/255.0, alpha: 1)
            loginButton.alpha = 1
            loginButton.isEnabled = true
        case .transitionning:
            print("transitioning")
            loginButton.alpha = 1
            loginButton.isEnabled = false
            loginButton.setTitle("Welcome!", for: .disabled)
            loadingView.alpha = 0
            present(FakeAfterLoginController(), animated: true, completion: nil)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}



class LoginInteractor {
    weak var delegate: ViewStateManaging?
    
    func loginUser(email: String, password: String) {

        delegate?.state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            //lets say our fake network call do not like login with z
            let success = !email.contains("z")
            if success {
                self.delegate?.state = .valid
                self.delegate?.state = .transitionning
            } else {
                self.delegate?.state = .error
                self.delegate?.state = .ready
            }
            
        })
    }
    
    func validate(email: String?, password: String?) {
        delegate?.state = .interacting
        
        let valid = isValid(email: email, password: password)
        if valid {
            delegate?.state = .valid
        } else {
            delegate?.state = .error
        }
        
        delegate?.state = .ready
    }
    
    func isValid(email: String?, password: String?) -> Bool {
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

