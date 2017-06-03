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
    
    let content1 = UIView()
    let content2 = UIView()
    let content3 = UIView()
    
    let testView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content1.backgroundColor = .red
        content2.backgroundColor = .green
        content3.backgroundColor = .gray
        testView.backgroundColor = .black
        
        scrollView.addSubview(content1)
        scrollView.addSubview(content2)
        scrollView.addSubview(content3)
        
        scrollView.backgroundColor = .yellow
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        
        view.addSubview(scrollView)
        content2.addSubview(testView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.configureFrame { maker in
            maker.size(width: 200, height: 200)
            maker.center()
        }
        
        content1.configureFrame { maker in
            maker.size(width: 100, height: 100)
            maker.center()
        }
        
        content2.configureFrame { maker in
            maker.size(width: 100, height: 100)
            maker.centerX()
            maker.top(to: content1.nui_bottom, inset: 10)
        }
        
        testView.configureFrame { maker in
            maker.size(width: 10, height: 10)
            maker.center()
        }
        
        content3.configureFrame { maker in
            maker.size(width: 50, height: 50)
            maker.left(to: testView.nui_right, inset: 10)
            maker.centerY(to: content2.nui_centerY)
        }
    }
}

