//
//  ViewController.swift
//  FramezillaExample
//
//  Created by Nikita Ermolenko on 13/05/2017.
//  Copyright © 2017 Nikita Ermolenko. All rights reserved.
//

import UIKit
import Framezilla

class ViewController: UIViewController {

    let scrollView = UIScrollView()
    let content = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content.backgroundColor = .red
        
        scrollView.addSubview(content)
        scrollView.backgroundColor = .yellow
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        
        view.addSubview(scrollView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.configureFrame { maker in
            maker.size(width: 100, height: 100)
            maker.center()
        }
        
        content.configureFrame { maker in
            maker.edges(top: 20, left: 10, bottom: 40, right: 30)
            
//            maker.edges(top: 10, left: 10, bottom: 10, right: 10)
            
//            maker.size(width: 100, height: 100)
//            maker.center()
        }
        
        print(content.frame)
    }
}

