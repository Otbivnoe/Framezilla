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

//        view.addSubview(content1)
//        view.addSubview(content2)
//        view.addSubview(content3)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let container = [content1, content2, content3, content4].container(in: view) {
            content1.configureFrame { maker in
                maker.centerX()
                maker.top()
                maker.size(width: 50, height: 50)
            }

            content2.configureFrame { maker in
                maker.top(to: content1.nui_bottom, inset: 5)
                maker.left()
                maker.size(width: 80, height: 80)
            }

            content3.configureFrame { maker in
                maker.top(to: content1.nui_bottom, inset: 15)
                maker.left(to: content2.nui_right, inset: 5)
                maker.size(width: 80, height: 80)
            }

            content4.configureFrame { maker in
                maker.top(to: content3.nui_bottom, inset: 5)
                maker.right()
                maker.size(width: 20, height: 20)
            }
        }

        container.configureFrame { maker in
            maker.center()
        }
    }
}

