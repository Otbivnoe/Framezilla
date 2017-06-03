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
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        
        view.addSubview(scrollView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        content.configureFrame { maker in
            maker.size(width: 100, height: 100)
            maker.center()
        }
    }

}

