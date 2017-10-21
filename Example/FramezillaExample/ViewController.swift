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

        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        scrollView.backgroundColor = .yellow
        scrollView.contentSize = CGSize(width: 500, height: 1000)

        content1.backgroundColor = .red
        content2.backgroundColor = .green
        content3.backgroundColor = .black

        view.backgroundColor = .yellow
        view.addSubview(content1)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        content1.configureFrame { maker in
            maker.top(to: nui_safeArea)
            maker.bottom(to: nui_safeArea)
            maker.right(to: nui_safeArea)
            maker.left(to: nui_safeArea)
        }
    }
}

