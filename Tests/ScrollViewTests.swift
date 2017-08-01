//
//  ScrollViewTests.swift
//  Framezilla
//
//  Created by Nikita Ermolenko on 03/06/2017.
//
//

import XCTest

final class ScrollViewTests: XCTestCase {
    
    var mainView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    var scrollView = UIScrollView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    override func setUp() {
        scrollView.contentSize = CGSize(width: 300, height: 300)
    }
    
    func testThanCorrectlyConfigures_edges_relativelyScrollViewWithNonZeroContentSize() {
        
        let view = UIView(frame: .zero)
        scrollView.addSubview(view)
        
        view.configureFrame { maker in
            maker.edges(top: 20, left: 10, bottom: 40, right: 30)
        }
        
        XCTAssertEqual(view.frame, CGRect(x: 10, y: 20, width: 260, height: 240))
        view.removeFromSuperview()
    }

    func testThanCorrectlyConfigures_edges_relativelyScrollViewWithZeroContentSize() {
        scrollView.contentSize = .zero

        let view = UIView(frame: .zero)
        scrollView.addSubview(view)

        view.configureFrame { maker in
            maker.edges(top: 20, left: 10, bottom: 40, right: 30)
        }

        XCTAssertEqual(view.frame, CGRect(x: 10, y: 20, width: 60, height: 40))
        view.removeFromSuperview()
    }

    func testThanCorrectlyConfigures_center_relativelyScrollView() {
        
        let view = UIView(frame: .zero)
        scrollView.addSubview(view)
        
        view.configureFrame { maker in
            maker.center()
            maker.size(width: 50, height: 40)
        }
        
        XCTAssertEqual(view.frame, CGRect(x: 125, y: 130, width: 50, height: 40))
        view.removeFromSuperview()
    }
    
    func testThanCorrectlyConfiguresFewSubviewTogether() {
        
        let view1 = UIView(frame: .zero)
        let view2 = UIView(frame: .zero)
        
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        
        view1.configureFrame { maker in
            maker.center()
            maker.size(width: 50, height: 40)
        }
        
        view2.configureFrame { maker in
            maker.centerX()
            maker.top(to: view1.nui_bottom, inset: 10)
            maker.size(width: 30, height: 30)
        }
        
        XCTAssertEqual(view1.frame, CGRect(x: 125, y: 130, width: 50, height: 40))
        XCTAssertEqual(view2.frame, CGRect(x: 135, y: 180, width: 30, height: 30))
        
        view1.removeFromSuperview()
        view2.removeFromSuperview()
    }
}
