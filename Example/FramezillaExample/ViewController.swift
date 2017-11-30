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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        content1.backgroundColor = .red
        content2.backgroundColor = .black
        content3.backgroundColor = .green

        view.addSubview(content1)
        view.addSubview(content2)
        view.addSubview(content3)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        content3.configureFrame { maker in
            maker.size(width: 50, height: 50)
            maker.top(inset: 100)
            maker.centerX(between: view.nui_left, view.nui_right)
        }

        content1.configureFrame { maker in
            maker.bottom(inset: 100)
            maker.right().left()
            maker.height(10)
        }

        content2.configureFrame { maker in
            maker.size(width: 50, height: 50)
            maker.centerX()
            maker.centerY(between: content1.nui_bottom, view.nui_bottom)
        }
    }
}

