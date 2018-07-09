//
//  ViewController.swift
//  TripApp
//
//  Created by 中嶋聖也 on 2018/07/01.
//  Copyright © 2018年 中嶋聖也. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var dataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showingData(_ sender: UIButton) {
        Alamofire.request("http://13.59.253.231/article/getDetail").responseJSON{ response in
            let json:JSON = JSON(response.result.value)
            print(json)
            SVProgressHUD.dismiss()
        }
        SVProgressHUD.show()
    }
}

