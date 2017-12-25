//
//  MakerWidthHeightTests.swift
//  Framezilla
//
//  Created by Nikita on 06/09/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import XCTest
@testable import Framezilla

class MakerWidthHeightTests: BaseTest {
    
    func testThatJustSetting_width_configuresCorrectly() {
        
        testingView.configureFrame { maker in
            maker.width(400)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 400, height: 50))
    }
    
    func testThatJustSetting_height_configuresCorrectly() {
        
        testingView.configureFrame { maker in
            maker.height(400)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 50, height: 400))
    }
    
    /* size */
    
    func testThat_size_configuresCorrectly() {
        
        testingView.configureFrame { maker in
            maker.size(width: 100, height: 99)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 100, height: 99))
    }
    
    /* with_to */
    
    func testThat_width_to_toAnotherView_width_configuresCorrectly() {
        
        testingView.configureFrame { maker in
            maker.width(to: nestedView2.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    func testThat_width_to_toAnotherView_height_configuresCorrectly() {
        
        testingView.configureFrame { maker in
            maker.width(to: nestedView2.nui_height, multiplier: 1)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 200, height: 50))
    }
    
    func testThat_width_to_toSelfView_height_configuresCorrectlyWithTopAndBottomSuperViewRelations() {
        
        testingView.configureFrame { maker in
            maker.top(inset: 10)
            maker.bottom(inset: 10)
            maker.width(to: testingView.nui_height, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 10, width: 240, height: 480))
    }
    
    func testThat_width_to_toSelfView_height_configuresCorrectlyWithTopAndBottomAnotherViewsRelations() {
        
        testingView.configureFrame { maker in
            maker.top(to: nestedView2.nui_top, inset: 10)
            maker.bottom(to: nestedView1.nui_bottom, inset: 10)
            maker.width(to: testingView.nui_height, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 160, width: 115, height: 230))
    }
    
    func testThat_width_to_configuresCorrectlyWithJustSettingHeight() {
        
        testingView.configureFrame { maker in
            maker.height(100)
            maker.width(to: testingView.nui_height, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 50, height: 100))
    }
    
    /* height_to */
    
    func testThat_height_to_toAnotherView_width_configuresCorrectly() {
        
        testingView.configureFrame { maker in
            maker.height(to: nestedView2.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 50, height: 100))
    }
    
    func testThat_height_to_toAnotherView_height_configuresCorrectly() {
        
        testingView.configureFrame { maker in
            maker.height(to: nestedView2.nui_height, multiplier: 1)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 50, height: 200))
    }
    
    func testThat_height_to_toSelfView_width_configuresCorrectlyWithLeftAndRightSuperViewRelations() {
        
        testingView.configureFrame { maker in
            maker.right(inset: 10)
            maker.left(inset: 10)
            maker.height(to: testingView.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 10, y: 0, width: 480, height: 240))
    }
    
    func testThat_height_to_toSelfView_width_configuresCorrectlyWithLeftAndRightAnotherViewsRelations() {
        
        testingView.configureFrame { maker in
            maker.right(to: nestedView1.nui_right, inset: 10)
            maker.left(to: nestedView1.nui_left, inset: 10)
            maker.height(to: testingView.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 110, y: 0, width: 280, height: 140))
    }
    
    func testThat_height_to_configuresCorrectlyWithJustSettingWidth() {
        
        testingView.configureFrame { maker in
            maker.width(100)
            maker.height(to: testingView.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    /* height_to with width_to */
    
    func testThat_height_to_correctlyConfiguresWithAnotherViewWidthAnd_width_to_toMyselfHeightRelation() {
        
        testingView.configureFrame { maker in
            maker.centerX()
            maker.centerY()
            maker.height(to: mainView.nui_width, multiplier: 0.5)
            maker.width(to: testingView.nui_height, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 187.5, y: 125, width: 125, height: 250))
    }
    
    func testThat_width_to_correctlyConfiguresWithAnotherViewHeightAnd_height_to_toMyselfWidthRelation() {
        
        testingView.configureFrame { maker in
            maker.centerX()
            maker.centerY()
            maker.width(to: mainView.nui_height, multiplier: 0.5)
            maker.height(to: testingView.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 125, y: 187.5, width: 250, height: 125))
    }

    /* width / height to fit */

    func testWidthToFit() {

        let label = UILabel()
        label.text = "HelloHelloHelloHello"

        label.configureFrame { maker in
            maker.widthToFit()
        }
        XCTAssertTrue(label.bounds.width > 0)
        XCTAssertEqual(label.bounds.height, 0)
    }

    func testHeightToFit() {

        let label = UILabel()
        label.text = "HelloHelloHelloHello"

        label.configureFrame { maker in
            maker.heightToFit()
        }
        XCTAssertTrue(label.bounds.height > 0)
        XCTAssertEqual(label.bounds.width, 0)
    }

    /* width / height that fits */

    func testThat_widthThatFits_correctlyConfiguresRelativeLowMaxWidth() {

        let label = UILabel()
        label.text = "HelloHelloHelloHello"

        label.configureFrame { maker in
            maker.widthThatFits(width: 30)
        }
        XCTAssertEqual(label.bounds.width, 30)
        XCTAssertEqual(label.bounds.height, 0)
    }

    func testThat_widthThatFits_correctlyConfiguresRelativeHighMaxWidth() {

        let label = UILabel()
        label.text = "HelloHelloHelloHello"

        label.configureFrame { maker in
            maker.widthThatFits(width: 300)
        }
        XCTAssertTrue(label.bounds.width != 300)
        XCTAssertEqual(label.bounds.height, 0)
    }

    func testThat_heightThatFits_correctlyConfiguresRelativeLowMaxHeight() {

        let label = UILabel()
        label.text = "HelloHelloHelloHello"

        label.configureFrame { maker in
            maker.heightThatFits(height: 5)
        }
        XCTAssertEqual(label.bounds.height, 5)
        XCTAssertEqual(label.bounds.width, 0)
    }

    func testThat_heightThatFits_correctlyConfiguresRelativeHighMaxHeight() {

        let label = UILabel()
        label.text = "HelloHelloHelloHello"

        label.configureFrame { maker in
            maker.heightThatFits(height: 300)
        }
        XCTAssertTrue(label.bounds.height != 300)
        XCTAssertEqual(label.bounds.width, 0)
    }
}
