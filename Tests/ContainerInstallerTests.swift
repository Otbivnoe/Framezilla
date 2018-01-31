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

        let container = [content1, content2, content3, content4].container(in: mainView) {
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

        XCTAssertEqual(container.frame, CGRect(x: 0, y: 0, width: 165, height: 170))
        XCTAssertEqual(content1.frame, CGRect(x: 57.5, y: 0, width: 50, height: 50))
        XCTAssertEqual(content2.frame, CGRect(x: 0, y: 55, width: 80, height: 80))
        XCTAssertEqual(content3.frame, CGRect(x: 85, y: 65, width: 80, height: 80))
        XCTAssertEqual(content4.frame, CGRect(x: 145, y: 150, width: 20, height: 20))
    }

    func testContainerConfigurationFromRightToLeft() {
        let content1 = UIView()
        let content2 = UIView()
        let content3 = UIView()

        let container = [content1, content2, content3].container(in: mainView) {
            content1.configureFrame { maker in
                maker.left()
                maker.centerY()
                maker.size(width: 50, height: 50)
            }

            content2.configureFrame { maker in
                maker.left(to: content1.nui_right, inset: 5)
                maker.centerY()
                maker.size(width: 30, height: 140)
            }

            content3.configureFrame { maker in
                maker.left(to: content2.nui_right, inset: 15)
                maker.centerY()
                maker.size(width: 80, height: 80)
            }
        }

        XCTAssertEqual(container.frame, CGRect(x: 0, y: 0, width: 180, height: 140))
        XCTAssertEqual(content1.frame, CGRect(x: 0, y: 45, width: 50, height: 50))
        XCTAssertEqual(content2.frame, CGRect(x: 55, y: 0, width: 30, height: 140))
        XCTAssertEqual(content3.frame, CGRect(x: 100, y: 30, width: 80, height: 80))
    }

    func testContainerConfigurationWithCenterYRelation() {
        let content1 = UIView()
        let content2 = UIView()

        let container = [content1, content2].container(in: mainView) {
            content1.configureFrame { maker in
                maker.top(inset: 10)
                maker.centerX()
                maker.size(width: 180, height: 50)
            }

            content2.configureFrame { maker in
                maker.top(to: content1.nui_bottom, inset: 10)
                maker.left()
                maker.size(width: 250, height: 200)
            }
        }

        XCTAssertEqual(container.frame, CGRect(x: 0, y: 0, width: 250, height: 270))
        XCTAssertEqual(content1.frame, CGRect(x: 35, y: 10, width: 180, height: 50))
        XCTAssertEqual(content2.frame, CGRect(x: 0, y: 70, width: 250, height: 200))
    }

    func testContainerConfigurationWithCenterXRelation() {
        let content1 = UIView()
        let content2 = UIView()

        let container = [content1, content2].container(in: mainView) {
            content2.configureFrame { maker in
                maker.top().left(inset: 10)
                maker.size(width: 200, height: 250)
            }

            content1.configureFrame { maker in
                maker.left(to: content2.nui_right, inset: 10)
                maker.centerY()
                maker.size(width: 50, height: 180)
            }
        }

        XCTAssertEqual(container.frame, CGRect(x: 0, y: 0, width: 270, height: 250))
        XCTAssertEqual(content1.frame, CGRect(x: 220, y: 35, width: 50, height: 180))
        XCTAssertEqual(content2.frame, CGRect(x: 10, y: 0, width: 200, height: 250))
    }
}
