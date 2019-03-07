//
//  ViewController.swift
//  SweetAutoLayout
//
//  Created by chunyang li on 03/01/2019.
//  Copyright (c) 2019 chunyang li. All rights reserved.
//

import UIKit
import SweetAutoLayout

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let v: UIView = UIView()
        self.view.addSubview(v)
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            (self.view.safeAreaLayoutGuide.left == v.left).isActive = true
            (v.right == self.view.safeAreaLayoutGuide.right).isActive = true
            (self.view.safeAreaLayoutGuide.top == v.top).isActive = true
            (v.bottom == self.view.safeAreaLayoutGuide.bottom).isActive = true
        } else {
            (self.topLayoutGuide.bottom == v.top).isActive = true
            (v.bottom == self.bottomLayoutGuide.top).isActive = true
            (self.view.left == v.left).isActive = true
            (v.right == self.view.right).isActive = true
        }
        
        (self.topLayoutGuide.top >= self.view.top * 3 + 30 ~ 400).isActive = true

        v.width == 30
    }

}

