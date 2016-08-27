//
//  NUIMaker.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

//Access control
enum NUIHandlerPriority {
    case NUIHandlerPriorityHigh
    case NUIHandlerPriorityMiddle
    case NUIHandlerPriorityLow
}

public final class NUIMaker {
    
    unowned let view: UIView
    
    var isTopFrameInstalled: Bool = false
    var isLeftFrameInstalled: Bool = false
    
    var handlers: [(NUIHandlerPriority, HandlerType)] = []
    var relationParameters: [(NUIRelationType, [Any])] = []
    var newRect: CGRect

    init(view: UIView) {
        self.view = view
        self.newRect = view.frame
    }
    
    public func and() -> NUIMaker {
        
        return self
    }

    //MARK: Asserts
    
    private func checkSuperviewAndRelationType(for view: UIView?, configurationBlock: (UIView, NUIRelationType) -> Void) -> Self {
        
        let relationView = view ?? self.view.superview!
        guard relationView.superview != nil else {
            assertionFailure("The view '\(relationView)' hasn't a superview.")
            return self
        }
        guard let relationType = relationView.relationType else {
            assertionFailure("The view '\(relationView)' hasn't a relation type.")
            return self
        }
        configurationBlock(relationView, relationType)
        return self
    }
    
    //MARK: High priority
    
    public func width(_ width: CGFloat) -> Self {
        
        let handler: HandlerType = { [unowned self] in
            self.setFrameValue(width, forRelation: .NUIRelationTypeWidth)
        }
        handlers.append((.NUIHandlerPriorityHigh, handler))
        relationParameters.append((.NUIRelationTypeHeight, [width]))
        return self
    }
    
    public func height(_ height: CGFloat) -> Self {
        
        let handler: HandlerType = { [unowned self] in
            self.setFrameValue(height, forRelation: .NUIRelationTypeWidth)
        }
        handlers.append((.NUIHandlerPriorityHigh, handler))
        relationParameters.append((.NUIRelationTypeHeight, [height]))
        return self
    }
    
    public func left(to view: UIView? = nil, inset: CGFloat = 0) -> Self {

        return checkSuperviewAndRelationType(for: view) { [unowned self] relationView, relationType in
            
            let handler: HandlerType = { [unowned self] in
                let x = self.convertedValue(relationType: relationType, forView: relationView) + inset
                var frame = self.newRect
                frame.origin.x = x
                self.newRect = frame
                self.isLeftFrameInstalled = true
            }
            self.handlers.append((.NUIHandlerPriorityHigh, handler))
            self.relationParameters.append((.NUIRelationTypeLeft, [view, inset, relationType]))
        }
    }
    
    public func top(to view: UIView? = nil, inset: CGFloat = 0) -> Self {

        return checkSuperviewAndRelationType(for: view) { [unowned self] relationView, relationType in
            
            let handler: HandlerType = { [unowned self] in
                let y = self.convertedValue(relationType: relationType, forView: relationView) + inset
                var frame = self.newRect
                frame.origin.y = y
                self.newRect = frame
                self.isTopFrameInstalled = true
            }
            self.handlers.append((.NUIHandlerPriorityHigh, handler))
            self.relationParameters.append((.NUIRelationTypeTop, [view, inset, relationType]))
        }
    }

    //MARK: Middle priority
}
