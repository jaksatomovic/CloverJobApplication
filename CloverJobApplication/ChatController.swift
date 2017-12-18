//
//  ChatController.swift
//  CloverJobApplication
//
//  Created by Jakša Tomović on 15/11/2017.
//  Copyright © 2017 Jakša Tomović. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import CRNotifications


class ChatController: UIViewController {
    
    let userInformation = UserDefaults.standard
    
    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.borderWidth = 2
        tv.layer.cornerRadius = 10
        tv.clipsToBounds = true
        return tv
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handelSend), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(messageTextView)
        view.addSubview(sendButton)
        
        messageTextView.anchor(view.topAnchor, left: view.leftAnchor, bottom: sendButton.topAnchor, right: view.rightAnchor, topConstant: 120, leftConstant: 32, bottomConstant: 30, rightConstant: 32, widthConstant: 0, heightConstant: 150)
        
        sendButton.anchor(messageTextView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 32, widthConstant: 100, heightConstant: 50)
    }
    @objc func handelSend() {
        if messageTextView.text == "" {
            CRNotifications.showNotification(type: .info, title: "Warning!", message: "You must enter your e-mail adress into text view.", dismissDelay: 3)
        } else {
            var parameters : NSDictionary!
            parameters = [
                "targetType": 3,
                "messageType": 1,
                "target" : "5a05ccd4829e64fd1dcd7732",
                "message" : messageTextView.text as Any
            ]
            self.view.endEditing(true)
            sendMessage(parameters)
        }
    }
    
    private func sendMessage(_ parameters : NSDictionary){
        
        let signinurl : String = Api.SERVER_BASE_URL + Api.MESSAGES_URL
        
        var request = URLRequest(url:URL(string: signinurl)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.addValue("GMUwQIHielm7b1ZQNNJYMAfCC508Giof", forHTTPHeaderField: "apikey")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(userInformation.string(forKey: UserDetails.ACCESS_TOKEN)!, forHTTPHeaderField: "access-token")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        Alamofire.request(request).responseJSON { (response) in
            if let statusCode = response.response?.statusCode {
                
                if statusCode == 200  {
                    CRNotifications.showNotification(type: .success, title: "Success!", message: "You successfully applied for a job.", dismissDelay: 3)
                    
                }else {
                    CRNotifications.showNotification(type: .error, title: "Error!", message: "Something went wrong! Please try again.", dismissDelay: 3)
                }
            }
        }
    }
}
