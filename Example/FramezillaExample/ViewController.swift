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
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.backgroundColor = .black
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button.setTitle("L", for: .normal)

        scrollView.backgroundColor = .yellow
        scrollView.contentSize = CGSize(width: 800, height: 300)

        content1.backgroundColor = .red
        content2.backgroundColor = .green

        scrollView.addSubview(content1)
        scrollView.addSubview(content2)

        view.addSubview(scrollView)
        view.addSubview(button)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        button.configureFrame { maker in
            maker.top(inset: 50)
            maker.right(inset: 50)
            maker.size(width: 50, height: 50)
        }

        scrollView.configureFrame { maker in
            maker.bottom().right().left()
            maker.height(300)
        }

        content1.configureFrame { maker in
            maker.top(inset: 10)
            maker.bottom(inset: 10)
            maker.right(inset: 10)
            maker.width(300)
        }

        print(content1.frame)
    }

    @objc private func action() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

