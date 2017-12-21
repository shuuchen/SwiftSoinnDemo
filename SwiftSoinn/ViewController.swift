//
//  ViewController.swift
//  SwiftSoinn
//
//  Created by Shuchen Du on 2016/07/10.
//  Copyright © 2016年 Shuchen Du. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        
        self.view = SignalView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

