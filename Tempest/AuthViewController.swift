//
//  ViewController.swift
//  Tempest
//
//  Created by Julien on 16/03/2017.
//  Copyright © 2017 Julien. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        api.auth(username: "user", password: "password") { (success) in
            if success {
                // DO  SOMETHING
            } else {
                return;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

