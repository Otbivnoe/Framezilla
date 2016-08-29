//
//  ViewController.swift
//  Example
//
//  Created by Nikita on 29/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import UIKit
import Framezilla

class ViewController: UIViewController {

    var view1: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    var view2: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(view1)
    }

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        view1.configureFrames { maker in
            maker.centerX()
            maker.centerY()
            maker.width(50)
            maker.height(to: self.view2.nui_height)
        }
    }
    
}

