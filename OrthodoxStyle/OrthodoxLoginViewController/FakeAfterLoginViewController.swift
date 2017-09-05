//
//  FakeAfterLoginViewController.swift
//  ViewStates
//
//  Created by sintaiyuan on 9/5/17.
//  Copyright © 2017 taiyungo. All rights reserved.
//

import UIKit

class FakeAfterLoginController : UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("logout")
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        
        let logOutButton = UIButton(frame: CGRect(x: view.frame.midX - 50, y: view.frame.midY - 22, width: 100, height: 44))
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        logOutButton.backgroundColor = UIColor.red
        
        view.addSubview(logOutButton)
    }
    
    func logOut() {
        dismiss(animated: true, completion: nil)
    }
}
