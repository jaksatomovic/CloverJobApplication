//
//  ViewController.swift
//  CloverJobApplication
//
//  Created by Jakša Tomović on 15/11/2017.
//  Copyright © 2017 Jakša Tomović. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import CRNotifications


class LoginController: UIViewController {
    
    let userInformation = UserDefaults.standard
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        tf.leftViewMode = UITextFieldViewMode.always
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 2
        tf.placeholder = "username"
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 2
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        tf.leftViewMode = UITextFieldViewMode.always
        tf.placeholder = "password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handelLogin), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        usernameTextField.anchor(view.topAnchor, left: view.leftAnchor, bottom: passwordTextField.topAnchor, right: view.rightAnchor, topConstant: 120, leftConstant: 32, bottomConstant: 20, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        passwordTextField.anchor(usernameTextField.bottomAnchor, left: view.leftAnchor, bottom: loginButton.topAnchor, right: view.rightAnchor, topConstant: 80, leftConstant: 32, bottomConstant: 40, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        loginButton.anchor(passwordTextField.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 32, widthConstant: 100, heightConstant: 50)
    }
    @objc func handelLogin() {
        if passwordTextField.text == "" || usernameTextField.text == "" {
            CRNotifications.showNotification(type: .info, title: "Warning!", message: "All fields must not be filled!", dismissDelay: 3)
        } else {
            var parameters : NSDictionary!
            parameters = [
                "organization": "clover",
                "username" : usernameTextField.text as Any,
                "password" : passwordTextField.text as Any
            ]
            handleSignIn(parameters)
        }
    }
    
    private func handleSignIn(_ parameters : NSDictionary){
        
        let signinurl : String = Api.SERVER_BASE_URL + Api.SIGNIN_URL
        
        var request = URLRequest(url:URL(string: signinurl)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("GMUwQIHielm7b1ZQNNJYMAfCC508Giof", forHTTPHeaderField: "apikey")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(request).responseDecodableObject(keyPath: nil, decoder: decoder) { (response: DataResponse<Repo>) in
            if let statusCode = response.response?.statusCode {
                
                if statusCode == 200  {
                    let repo = response.result.value
                    print(repo?.access_token as Any)
                    self.userInformation.setValue(repo?.access_token, forKey: UserDetails.ACCESS_TOKEN)
                    let vc = ChatController()
                    self.show(vc, sender: self)
                } else {
                     CRNotifications.showNotification(type: .error, title: "Error!", message: "Something went wrong! Please try again.", dismissDelay: 3)
                }
            }
        }
    }
}

