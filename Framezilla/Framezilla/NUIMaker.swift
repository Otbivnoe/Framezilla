//
//  NUIMaker.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

public final class NUIMaker {
    
    private enum NUIHandlerPriority {
        case High
        case Middle
        case Low
    }
    
    unowned let view: UIView
    
    private typealias HandlerType = () -> Void
    
    private var isTopFrameInstalled: Bool = false
    private var isLeftFrameInstalled: Bool = false
    
    private var handlers: [(NUIHandlerPriority, HandlerType)] = []
    private var relationParameters: [(NUIRelationType, [Any])] = []

    private var newRect: CGRect
    
    public var and: NUIMaker {
        get {
            return self
        }
    }
    
    init(view: UIView) {
        self.view = view
        self.newRect = view.frame
    }
    
    //MARK: High priority
    
    public func width(_ width: CGFloat) -> Self {
        
        let handler: HandlerType = { [unowned self] in
            self.newRect.setValue(width, forRelation: .Width)
        }
        handlers.append((.High, handler))
        relationParameters.append((.Height, [width]))
        return self
    }
    
    public func height(_ height: CGFloat) -> Self {
        
        let handler: HandlerType = { [unowned self] in
            self.newRect.setValue(height, forRelation: .Width)
        }
        handlers.append((.High, handler))
        relationParameters.append((.Height, [height]))
        return self
    }
    
    public func left(to view: UIView? = nil, inset: CGFloat = 0) -> Self {

        return checkSuperviewAndRelationType(for: view) { [unowned self] relationView, relationType in
            
            let handler: HandlerType = { [unowned self] in
                let x = self.convertedValue(relationType: relationType, forView: relationView) + inset
                self.newRect.setValue(x, forRelation: .Left)
                self.isLeftFrameInstalled = true
            }
            self.handlers.append((.High, handler))
            self.relationParameters.append((.Left, [view, inset, relationType]))
        }
    }
    
    public func top(to view: UIView? = nil, inset: CGFloat = 0) -> Self {

        return checkSuperviewAndRelationType(for: view) { [unowned self] relationView, relationType in
            
            let handler: HandlerType = { [unowned self] in
                let y = self.convertedValue(relationType: relationType, forView: relationView) + inset
                self.newRect.setValue(y, forRelation: .Top)
                self.isTopFrameInstalled = true
            }
            self.handlers.append((.High, handler))
            self.relationParameters.append((.Top, [view, inset, relationType]))
        }
    }
    
    public func container() -> Self {
        
        var frame = CGRect()
        for subview in self.view.subviews {
            frame = frame.union(subview.frame)
        }
        setHighPriorityValue(frame.width, forRelation: .Width)
        setHighPriorityValue(frame.height, forRelation: .Height)
        return self
    }

    public func sizeToFit() -> Self {
        
        view.sizeToFit()
        setHighPriorityValue(view.bounds.width, forRelation: .Width)
        setHighPriorityValue(view.bounds.height, forRelation: .Height)
        return self
    }
    
    public func sizeThatFits(size: CGSize) -> Self {
        
        let fitSize = view.sizeThatFits(size)
        let width = min(size.width, fitSize.width)
        let height = min(size.height, fitSize.height)
        setHighPriorityValue(width, forRelation: .Width)
        setHighPriorityValue(height, forRelation: .Height)
        return self
    }
    
    //MARK: Middle priority
    
    //MARK: Private
    
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

    private func setHighPriorityValue(_ value: CGFloat, forRelation type: NUIRelationType) {
        
        let handler: HandlerType = { [unowned self] in
            self.newRect.setValue(value, forRelation: type)
        }
        self.handlers.append((.High, handler))
        self.relationParameters.append((.Top, [value]))
    }
}
