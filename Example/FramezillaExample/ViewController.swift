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

        scrollView.backgroundColor = .yellow
        scrollView.contentSize = CGSize(width: 500, height: 1000)

        content1.backgroundColor = .red
        content2.backgroundColor = .green
        content3.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.addSubview(content2)

//        view.addSubview(content3)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        content1.configureFrame { maker in
//            maker.edges(top: 0, left: 0, right: 0)
//            maker.height(50)
//        }
//        
//        content2.configureFrame { maker in
//            maker.edges(left: 0, bottom: 0, right: 0)
//            maker.height(200)
//        }
//        
//        content3.configureFrame { maker in
//            maker.size(width: 20, height: 70)
//            maker.centerY(between: content2, content1)
//            maker.centerX()
//        }


//        content1.configureFrame { maker in
//            maker.edges(top: 0, left: 0, bottom: 0)
//            maker.width(50)
//        }
//        
//        content2.configureFrame { maker in
//            maker.edges(top: 0, bottom: 0, right: 0)
//            maker.width(200)
//        }
//        
//        content3.configureFrame { maker in
//            maker.size(width: 20, height: 70)
//            maker.centerX(between: content1, content2)
//            maker.centerY()
//        }

        scrollView.configureFrame { maker in
            maker.margin(20)
        }

        content2.configureFrame { maker in
            maker.size(width: 100, height: 100)
            maker.left()
            maker.centerY()
        }
    }
}

