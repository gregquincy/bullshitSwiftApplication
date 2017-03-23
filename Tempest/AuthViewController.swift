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
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request = URLRequest(url: NSURL(string: "http://127.0.0.1:8000/")! as URL)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print(response)
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

