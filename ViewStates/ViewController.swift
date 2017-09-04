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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textDidChange(emailTF)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        loginInteractor.loginUser()
    }
    
    
    @IBAction func textDidChange(_ sender: UITextField) {
        var email = emailTF.text ?? ""
        var password = passwordTF.text ?? ""
        
        if sender == emailTF {
            email = sender.text ?? ""
        }
        
        if sender == passwordTF {
            password = sender.text ?? ""
        }
        
        loginInteractor.validate(email: email, password: password)
    }
}



extension ViewController : ViewStateManaging {
    enum ViewState {
        case ready
        case interacting
        case loading
        case valid
        case error
        case transitionning
    }
    
    func render() {
        switch state {
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
        case .valid:
            print("valid")
            view.backgroundColor = UIColor(colorLiteralRed: 133/255.0, green: 221/255.0, blue: 169/255.0, alpha: 1)
            loginButton.alpha = 1
            loginButton.isEnabled = true
        case .transitionning:
            print("transitioning")
            loginButton.alpha = 1
            loginButton.isEnabled = false
            loadingView.alpha = 0
            UIApplication.shared.beginIgnoringInteractionEvents()
//animating transition
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}



class LoginInteractor {
    weak var delegate: ViewStateManaging?
    
    func loginUser() {

        delegate?.state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.delegate?.state = .ready
        })
    }
    
    func validate(email: String, password: String) {
        delegate?.state = .interacting
        
        if email.isEmpty || password.isEmpty {
            delegate?.state = .error
        } else {
            delegate?.state = .valid
        }
        
        delegate?.state = .ready
    }
}

