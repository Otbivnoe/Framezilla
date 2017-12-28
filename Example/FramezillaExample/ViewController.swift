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

    let content1 = UIView()
    let content2 = UIView()
    let content3 = UIView()
    let content4 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        content1.backgroundColor = .red
        content2.backgroundColor = .black
        content3.backgroundColor = .green
        content4.backgroundColor = .gray

        view.addSubview(content1)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        content1.configureFrame { maker in
            maker.size(width: 100, height: 100)
            maker.right(inset: 10)
            maker.top(inset: 10)
        }
    }
}

