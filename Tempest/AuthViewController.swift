//
//  ViewController.swift
//  Tempest
//
//  Created by Julien on 16/03/2017.
//  Copyright © 2017 Julien. All rights reserved.
//

import UIKit
import Alamofire

class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        api.auth(username: "user", password: "password") { (success) in
            if success {
                let param :Parameters = ["lat":"0", "lon":"0"]
                api.req("/reports/", .get, param).responseJSON{ response in
                    switch response.result {
                    case .success:
                        debugPrint(response)
                        print("Validation Successful")
                    case .failure(let error):
                        print(error)
                    }
                }
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

