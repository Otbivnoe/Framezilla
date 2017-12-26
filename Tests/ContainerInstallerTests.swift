//
//  ContainerInstallerTests.swift
//  FramezillaTests
//
//  Created by Nikita Ermolenko on 26/12/2017.
//

import XCTest

class ContainerInstallerTests: BaseTest {

    func testContainerConfigurationFromTopToBottom() {
        let content1 = UIView()
        let content2 = UIView()
        let content3 = UIView()
        let content4 = UIView()

        _ = [content1, content2, content3, content4].container(in: mainView) {
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
        
        XCTAssertEqual(content1.frame, CGRect(x: 70, y: 0, width: 50, height: 50))
        XCTAssertEqual(content2.frame, CGRect(x: 0, y: 55, width: 80, height: 80))
        XCTAssertEqual(content3.frame, CGRect(x: 85, y: 65, width: 80, height: 80))
        XCTAssertEqual(content4.frame, CGRect(x: 170, y: 150, width: 20, height: 20))
    }

    func testContainerConfigurationFromRightToLeft() {
        let content1 = UIView()
        let content2 = UIView()
        let content3 = UIView()

        _ = [content1, content2, content3].container(in: mainView) {
            content1.configureFrame { maker in
                maker.right()
                maker.centerY()
                maker.size(width: 50, height: 50)
            }

            content2.configureFrame { maker in
                maker.right(to: content1.nui_left, inset: 5)
                maker.centerY()
                maker.size(width: 30, height: 140)
            }

            content3.configureFrame { maker in
                maker.right(to: content2.nui_left, inset: 15)
                maker.centerY()
                maker.size(width: 80, height: 80)
            }
        }

        XCTAssertEqual(content1.frame, CGRect(x: 130, y: 45, width: 50, height: 50))
        XCTAssertEqual(content2.frame, CGRect(x: 95, y: 0, width: 30, height: 140))
        XCTAssertEqual(content3.frame, CGRect(x: 0, y: 30, width: 80, height: 80))
    }
}
