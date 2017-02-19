//
//  StateTests.swift
//  Framezilla
//
//  Created by Nikita on 06/09/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import XCTest

class StateTests: BaseTest {

    func testThatFrameForStatesChangesCorrectly() {
        
        mainView.addSubview(testingView)
        
        testingView.nui_state = 1
        configureFrames()

        XCTAssertEqual(testingView.frame, CGRect(x: 230, y: 240, width: 40, height: 20))
        
        testingView.nui_state = "DEFAULT VALUE"
        configureFrames()
        
        XCTAssertEqual(testingView.frame, CGRect(x: 245, y: 245, width: 10, height: 10))
    }
    
    private func configureFrames() {
        
        testingView.configureFrames { maker in
            maker.width(10)
            maker.height(10)
            maker.centerX().and.centerY()
        }
        
        testingView.configureFrames(state: 1) { maker in
            maker.width(40)
            maker.height(20)
            maker.centerX().and.centerY()
        }
    }

}
