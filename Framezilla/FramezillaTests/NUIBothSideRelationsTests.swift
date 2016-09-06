//
//  NUIBothSideRelationsTests.swift
//  Framezilla
//
//  Created by Nikita on 06/09/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import XCTest

class NUIBothSideRelationsTests: XCTestCase {
    
    var mainView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    var nestedView: UIView = UIView(frame: CGRect(x: 10, y: 10, width: 480, height: 480))
    var testingView: UIView = UIView()
    
    override func setUp() {
        super.setUp()
        
        mainView.addSubview(testingView)
        mainView.addSubview(nestedView)
        testingView.frame = CGRect.zero
    }

    override func tearDown() {
        super.tearDown()

        testingView.removeFromSuperview()
        nestedView.removeFromSuperview()
    }
    
    /* rigth-left */
    
    func testThanRightAndLeftForSuperviewConfiguresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.centerY()
            maker.height(100)
            maker.left(inset: 10).and.right(inset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 10, y: 200, width: 480, height: 100))
    }
    
    func testThanRightAndLeftForAnotherViewConfiguresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.centerY()
            maker.height(100)
            maker.left(to: self.nestedView.nui_left, inset: 10)
            maker.right(to: self.nestedView.nui_right, inset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 20, y: 200, width: 460, height: 100))
    }
    
    /* top-bottom */
    
    func testThanBottomtAndTopForSuperviewConfiguresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.centerX()
            maker.width(100)
            maker.top(inset: 10).and.bottom(inset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 200, y: 10, width: 100, height: 480))
    }
    
    func testThanBottomtAndTopForAnotherViewConfiguresCorrectly() {
        
        testingView.configureFrames { maker in
            maker.centerX()
            maker.width(100)
            maker.top(to: self.nestedView.nui_top, inset: 10)
            maker.bottom(to: self.nestedView.nui_bottom, inset: 10)
        }
        XCTAssertEqual(testingView.frame, CGRect(x: 200, y: 20, width: 100, height: 460))
    }
}
