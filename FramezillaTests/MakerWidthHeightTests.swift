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
    
    func testThanJustSetting_width_configuresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.width(400)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 400, height: 50))
    }
    
    func testThanJustSetting_height_configuresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.height(400)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 50, height: 400))
    }
    
    /* size */
    
    func testThan_size_configuresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.size(width: 100, height: 99)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 100, height: 99))
    }
    
    /* with_to */
    
    func testThan_width_to_toAnotherView_width_configuresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.width(to: self.nestedView2.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    func testThan_width_to_toAnotherView_height_configuresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.width(to: self.nestedView2.nui_height, multiplier: 1)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 200, height: 50))
    }
    
    func testThan_width_to_toSelfView_height_configuresCorrectlyWithTopAndBottomSuperViewRelations() {
        
        testingView.configureFrames { maker in
            maker.top(inset: 10)
            maker.bottom(inset: 10)
            maker.width(to: self.testingView.nui_height, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 10, width: 240, height: 480))
    }
    
    func testThan_width_to_toSelfView_height_configuresCorrectlyWithTopAndBottomAnotherViewsRelations() {
        
        testingView.configureFrames { maker in
            maker.top(to: self.nestedView2.nui_top, inset: 10)
            maker.bottom(to: self.nestedView1.nui_bottom, inset: 10)
            maker.width(to: self.testingView.nui_height, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 160, width: 115, height: 230))
    }
    
    func testThan_width_to_configuresCorrectlyWithJustSettingHeight() {
        
        testingView.configureFrames { maker in
            maker.height(100)
            maker.width(to: self.testingView.nui_height, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 50, height: 100))
    }
    
    /* height_to */
    
    func testThan_height_to_toAnotherView_width_configuresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.height(to: self.nestedView2.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 50, height: 100))
    }
    
    func testThan_height_to_toAnotherView_height_configuresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.height(to: self.nestedView2.nui_height, multiplier: 1)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 50, height: 200))
    }
    
    func testThan_height_to_toSelfView_width_configuresCorrectlyWithLeftAndRightSuperViewRelations() {
        
        testingView.configureFrames { maker in
            maker.right(inset: 10)
            maker.left(inset: 10)
            maker.height(to: self.testingView.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 10, y: 0, width: 480, height: 240))
    }
    
    func testThan_height_to_toSelfView_width_configuresCorrectlyWithLeftAndRightAnotherViewsRelations() {
        
        testingView.configureFrames { maker in
            maker.right(to: self.nestedView1.nui_right, inset: 10)
            maker.left(to: self.nestedView1.nui_left, inset: 10)
            maker.height(to: self.testingView.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 110, y: 0, width: 280, height: 140))
    }
    
    func testThan_height_to_configuresCorrectlyWithJustSettingWidth() {
        
        testingView.configureFrames { maker in
            maker.width(100)
            maker.height(to: self.testingView.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    /* height_to with width_to */
    
    func testThan_height_to_correctlyConfiguresWithAnotherViewWidthAnd_width_to_toMyselfHeightRelation() {
        
        testingView.configureFrames { maker in
            maker.centerX()
            maker.centerY()
            maker.height(to: self.mainView.nui_width, multiplier: 0.5)
            maker.width(to: self.testingView.nui_height, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 187.5, y: 125, width: 125, height: 250))
    }
    
    func testThan_width_to_correctlyConfiguresWithAnotherViewHeightAnd_height_to_toMyselfWidthRelation() {
        
        testingView.configureFrames { maker in
            maker.centerX()
            maker.centerY()
            maker.width(to: self.mainView.nui_height, multiplier: 0.5)
            maker.height(to: self.testingView.nui_width, multiplier: 0.5)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 125, y: 187.5, width: 250, height: 125))
    }
}
