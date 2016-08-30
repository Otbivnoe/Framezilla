//
//  NUIMaker.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

enum NUIHandlerPriority: Int {
    case High = 0
    case Middle
    case Low
}

public final class NUIMaker {
    
    typealias HandlerType = () -> Void
    typealias RelationParametersType = (type: NUIRelationType, argument: Any)

    unowned let view: UIView
    
    var handlers:           [(priority: NUIHandlerPriority, handler: HandlerType)] = []
    var relationParameters: [RelationParametersType] = []
    var newRect: CGRect
    
    public var and: NUIMaker {
        get {
            return self
        }
    }
    
    init(_ view: UIView) {
        self.view = view
        self.newRect = view.frame
    }
    
    //MARK: Additions
    
    @discardableResult public func edges(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> NUIMaker {
        
        return apply(self.top, top).apply(self.left, left).apply(self.bottom, bottom).apply(self.right, right)
    }
    
    private func apply(_ f: ((UIView?, CGFloat) -> NUIMaker), _ inset: CGFloat?) -> NUIMaker {
        
        return (inset != nil) ? f(nil, inset!) : self
    }
    
    //MARK: High priority
    
    @discardableResult public func width(_ width: CGFloat) -> Self {
        
        let handler = { [unowned self] in
            self.newRect.setValue(width, forRelation: .Width)
        }
        handlers.append((.High, handler))
        relationParameters.append((.Width, width))
        return self
    }
    
    @discardableResult public func width(to view: UIView, multiplier: CGFloat = 1.0) -> Self {
    
        return checkSuperviewAndRelationType(for: view) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                if relationView != self.view {
                    let width = self.relationSize(view: relationView, relationType: relationType) * multiplier
                    self.newRect.setValue(width, forRelation: .Width)
                }
                else {
                    if let heightParameters = self.relationParameters(relationType: .Height) {
                        
                        let width = heightParameters.argument as! CGFloat
                        self.newRect.setValue(width, forRelation: .Width)
                    }
                    else if let heightToParameters = self.relationParameters(relationType: .HeightTo) {

                        let (tempView, tempMultiplier, tempRelationType) = heightToParameters.argument as! (UIView, CGFloat, NUIRelationType)
                        let width = self.relationSize(view: tempView, relationType: tempRelationType) * (tempMultiplier * multiplier)
                        self.newRect.setValue(width, forRelation: .Width)
                    }
                    else {
                        guard let topParameters = self.relationParameters(relationType: .Top), let bottomParameters = self.relationParameters(relationType: .Bottom) else {
                            assertionFailure("\(#function) : Not enough data for configure frame.")
                            return
                        }
                        
                        let (topView, topInset, topRelationType) = topParameters.argument as! (UIView, CGFloat, NUIRelationType)
                        let (bottomView, bottomInset, bottomRelationType) = bottomParameters.argument as! (UIView, CGFloat, NUIRelationType)

                        let topViewY = self.convertedValue(relationType: topRelationType, forView: topView) + topInset
                        let bottomViewY = self.convertedValue(relationType: bottomRelationType, forView: bottomView) - bottomInset
                        
                        self.newRect.setValue((bottomViewY - topViewY)*multiplier, forRelation: .Width)
                    }
                }
            }
            self.handlers.append((.High, handler))
            self.relationParameters.append((.WidthTo, (relationView, multiplier, relationType)))
        }
    }

    @discardableResult public func height(_ height: CGFloat) -> Self {
        
        let handler = { [unowned self] in
            self.newRect.setValue(height, forRelation: .Height)
        }
        handlers.append((.High, handler))
        relationParameters.append((.Height, height))
        return self
    }
    
    @discardableResult public func height(to view: UIView, multiplier: CGFloat = 1.0) -> Self {
        
        return checkSuperviewAndRelationType(for: view) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                if relationView != self.view {
                    let height = self.relationSize(view: relationView, relationType: relationType) * multiplier
                    self.newRect.setValue(height, forRelation: .Height)
                }
                else {
                    if let widthParameters = self.relationParameters(relationType: .Width) {
                        
                        let height = widthParameters.argument as! CGFloat
                        self.newRect.setValue(height, forRelation: .Height)
                    }
                    else if let widthToParameters = self.relationParameters(relationType: .WidthTo) {
                        
                        let (tempView, tempMultiplier, tempRelationType) = widthToParameters.argument as! (UIView, CGFloat, NUIRelationType)
                        let height = self.relationSize(view: tempView, relationType: tempRelationType) * (tempMultiplier * multiplier)
                        self.newRect.setValue(height, forRelation: .Height)
                    }
                    else {
                        guard let leftParameters = self.relationParameters(relationType: .Left), let rightParameters = self.relationParameters(relationType: .Right) else {
                            assertionFailure("\(#function) : Not enough data for configure frame.")
                            return
                        }
                        
                        let (leftView, leftInset, leftRelationType) = leftParameters.argument as! (UIView, CGFloat, NUIRelationType)
                        let (rightView, rightInset, rightRelationType) = rightParameters.argument as! (UIView, CGFloat, NUIRelationType)
                        
                        let leftViewX = self.convertedValue(relationType: leftRelationType, forView: leftView) + leftInset
                        let rightViewX = self.convertedValue(relationType: rightRelationType, forView: rightView) - rightInset
                        
                        self.newRect.setValue((rightViewX - leftViewX)*multiplier, forRelation: .Height)
                    }
                }
            }
            self.handlers.append((.High, handler))
            self.relationParameters.append((.HeightTo, (relationView, multiplier, relationType)))
        }
    }
    
    @discardableResult public func size(width: CGFloat, height: CGFloat) -> Self {
        
        return self.width(width).height(height)
    }
    
    @discardableResult public func left(to view: UIView? = nil, inset: CGFloat = 0.0) -> Self {

        return checkSuperviewAndRelationType(for: view ?? self.view.superview!.nui_left) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                let x = self.convertedValue(relationType: relationType, forView: relationView) + inset
                self.newRect.setValue(x, forRelation: .Left)
            }
            self.handlers.append((.High, handler))
            self.relationParameters.append((.Left, (relationView, inset, relationType)))
        }
    }
    
    @discardableResult public func top(to view: UIView? = nil, inset: CGFloat = 0.0) -> Self {

        return checkSuperviewAndRelationType(for: view ?? self.view.superview!.nui_top) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                let y = self.convertedValue(relationType: relationType, forView: relationView) + inset
                self.newRect.setValue(y, forRelation: .Top)
            }
            self.handlers.append((.High, handler))
            self.relationParameters.append((.Top, (relationView, inset, relationType)))
        }
    }
    
    @discardableResult public func container() -> Self {
        
        var frame = CGRect.zero
        for subview in self.view.subviews {
            frame = frame.union(subview.frame)
        }
        setHighPriorityValue(frame.width, forRelation: .Width)
        setHighPriorityValue(frame.height, forRelation: .Height)
        return self
    }

    @discardableResult public func sizeToFit() -> Self {
        
        view.sizeToFit()
        setHighPriorityValue(view.bounds.width, forRelation: .Width)
        setHighPriorityValue(view.bounds.height, forRelation: .Height)
        return self
    }
    
    @discardableResult public func sizeThatFits(size: CGSize) -> Self {
        
        let fitSize = view.sizeThatFits(size)
        let width = min(size.width, fitSize.width)
        let height = min(size.height, fitSize.height)
        setHighPriorityValue(width, forRelation: .Width)
        setHighPriorityValue(height, forRelation: .Height)
        return self
    }
    
    //MARK: Middle priority
    
    @discardableResult public func edges(insets: UIEdgeInsets = UIEdgeInsets.zero) -> Self {
        
        let handler = { [unowned self] in
            let width = self.view.superview!.bounds.width - (insets.left + insets.right)
            let height = self.view.superview!.bounds.height - (insets.left + insets.right)
            let frame = CGRect(x: insets.left, y: insets.top, width: width, height: height)
            self.newRect = frame
        }
        self.handlers.append((.Middle, handler))
        return self
    }
    
    @discardableResult public func bottom(to view: UIView? = nil, inset: CGFloat = 0.0) -> Self {
        
        return checkSuperviewAndRelationType(for: view ?? self.view.superview!.nui_bottom) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                if self.isExistsRelationParameters(relationType: .Top) {
                    let height = fabs(self.newRect.minY - self.convertedValue(relationType: relationType, forView: relationView)) - inset
                    self.newRect.setValue(height, forRelation: .Height)
                }
                else {
                    let y = self.convertedValue(relationType: relationType, forView: relationView) - inset - self.newRect.height
                    self.newRect.setValue(y, forRelation: .Top)
                }
            }
            self.handlers.append((.Middle, handler))
            self.relationParameters.append((.Bottom, (relationView, inset, relationType)))
        }
    }
    
    @discardableResult public func right(to view: UIView? = nil, inset: CGFloat = 0.0) -> Self {
        
        return checkSuperviewAndRelationType(for: view ?? self.view.superview!.nui_right) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                if self.isExistsRelationParameters(relationType: .Left) {
                    let width = fabs(self.newRect.minX - self.convertedValue(relationType: relationType, forView: relationView)) - inset
                    self.newRect.setValue(width, forRelation: .Width)
                }
                else {
                    let x = self.convertedValue(relationType: relationType, forView: relationView) - inset - self.newRect.width
                    self.newRect.setValue(x, forRelation: .Left)
                }
            }
            self.handlers.append((.Middle, handler))
            self.relationParameters.append((.Right, (relationView, inset, relationType)))
        }
    }
    
    //MARK: Low priority
    
    @discardableResult public func centerY(to view: UIView? = nil, offset: CGFloat = 0.0) -> Self {
        
        return checkSuperviewAndRelationType(for: view ?? self.view.superview!.nui_centerY) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                let y = self.convertedValue(relationType: relationType, forView: relationView) - self.newRect.height/2 - offset
                self.newRect.setValue(y, forRelation: .Top)
            }
            self.handlers.append((.Low, handler))
        }
    }
    
    @discardableResult public func centerX(to view: UIView? = nil, offset: CGFloat = 0.0) -> Self {
        
        return checkSuperviewAndRelationType(for: view ?? self.view.superview!.nui_centerX) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                let x = self.convertedValue(relationType: relationType, forView: relationView) - self.newRect.width/2 - offset
                self.newRect.setValue(x, forRelation: .Left)
            }
            self.handlers.append((.Low, handler))
        }
    }
    
    @discardableResult public func setCenterX(value: CGFloat) -> Self {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value, forRelation: .CenterX)
        }
        self.handlers.append((.Low, handler))
        return self
    }
    
    @discardableResult public func setCenterY(value: CGFloat) -> Self {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value, forRelation: .CenterY)
        }
        self.handlers.append((.Low, handler))
        return self
    }
    
    //MARK: Private
    
    private func checkSuperviewAndRelationType(for relationView: UIView, configurationBlock: (UIView, NUIRelationType) -> Void) -> Self {

        assert(relationView.relationType != nil, "The view '\(relationView)' hasn't a relation type.")
        configurationBlock(relationView, relationView.relationType!)
        return self
    }

    private func setHighPriorityValue(_ value: CGFloat, forRelation type: NUIRelationType) {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value, forRelation: type)
        }
        self.handlers.append((.High, handler))
        self.relationParameters.append((type, value))
    }
}

