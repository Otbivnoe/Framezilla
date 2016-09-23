//
//  MakerCenterTests.swift
//  Framezilla
//
//  Created by Nikita on 06/09/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import XCTest

class MakerCenterTests: BaseTest {
    
    /* super centerX */
    
    func testThanCorrectlyConfigures_centerX_forRelativelySuperViewWith_zeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerX()
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 225, y: 0, width: 50, height: 50))
    }
    
    func testThanCorrectlyConfigures_centerX_forRelativelySuperViewWith_nonZeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerX(offset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 215, y: 0, width: 50, height: 50))
    }
    
    
    /* super centerY */
    
    func testThanCorrectlyConfigures_centerY_forRelativelySuperViewWith_zeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerY()
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 225, width: 50, height: 50))
    }
    
    func testThanCorrectlyConfigures_centerY_forRelativelySuperViewWith_nonZeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerY(offset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 215, width: 50, height: 50))
    }
    
    
    /* centerX with nui_left */
    
    func testThanCorrectlyConfigures_centerX_withAnotherView_left_relationWith_zeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerX(to: self.nestedView2.nui_left)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 125, y: 0, width: 50, height: 50))
    }
    
    func testThanCorrectlyConfigures_centerX_withAnotherView_left_relationWith_nonZeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerX(to: self.nestedView2.nui_left, offset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 115, y: 0, width: 50, height: 50))
    }
    
    /* centerX with nui_centerX */
    
    func testThanCorrectlyConfigures_centerX_withAnotherView_centerX_relationWith_zeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerX(to: self.nestedView2.nui_centerX)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 225, y: 0, width: 50, height: 50))
    }
    
    func testThanCorrectlyConfigures_centerX_withAnotherView_centerX_relationWith_nonZeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerX(to: self.nestedView2.nui_centerX, offset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 215, y: 0, width: 50, height: 50))
    }
    
    /* centerX with nui_right */
    
    func testThanCorrectlyConfigures_centerX_withAnotherView_right_relationWith_zeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerX(to: self.nestedView2.nui_right)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 325, y: 0, width: 50, height: 50))
    }
    
    func testThanCorrectlyConfigures_centerX_withAnotherView_right_relationWith_nonZeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerX(to: self.nestedView2.nui_right, offset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 315, y: 0, width: 50, height: 50))
    }
    
    
    /* centerY with nui_left */
    
    func testThanCorrectlyConfigures_centerY_withAnotherView_left_relationWith_zeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerY(to: self.nestedView2.nui_left)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 125, width: 50, height: 50))
    }
    
    func testThanCorrectlyConfigures_centerY_withAnotherView_left_relationWith_nonZeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerY(to: self.nestedView2.nui_left, offset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 115, width: 50, height: 50))
    }
    
    /* centerY with nui_centerX */
    
    func testThanCorrectlyConfigures_centerY_withAnotherView_centerX_relationWith_zeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerY(to: self.nestedView2.nui_centerX)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 225, width: 50, height: 50))
    }
    
    func testThanCorrectlyConfigures_centerY_withAnotherView_centerX_relationWith_nonZeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerY(to: self.nestedView2.nui_centerX, offset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 215, width: 50, height: 50))
    }
    
    /* centerY with nui_right */
    
    func testThanCorrectlyConfigures_centerY_withAnotherView_right_relationWith_zeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerY(to: self.nestedView2.nui_right)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 325, width: 50, height: 50))
    }
    
    func testThanCorrectlyConfigures_centerY_withAnotherView_right_relationWith_nonZeroOffset() {
        
        testingView.configureFrames { maker in
            maker.centerY(to: self.nestedView2.nui_right, offset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 0, y: 315, width: 50, height: 50))
    }
    
    
    /* just setting centerX and centerY*/
    
    func testThanCorrectlyConfiguresSettingValueForCenterYAndCenterX() {
        
        testingView.configureFrames { maker in
            maker.setCenterX(value: 30)
            maker.setCenterY(value: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 5, y: -15, width: 50, height: 50))
    }
    
}
