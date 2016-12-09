//
//  Maker.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

enum HandlerPriority: Int {
    case high
    case middle
    case low
}

public final class Maker {
    
    typealias HandlerType = () -> Void
    typealias RelationParametersType = (type: RelationType, argument: Any)

    unowned let view: UIView
    
    var handlers:           [(priority: HandlerPriority, handler: HandlerType)] = []
    var relationParameters: [RelationParametersType] = []
    var newRect: CGRect

    init(_ view: UIView) {
        self.view = view
        self.newRect = view.frame
    }
    
    //MARK: Additions
    
    ///	Optional semantic property for improvements readability.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    public var and: Maker {
        get {
            return self
        }
    }
    
    ///	ROFL semantic property.
    ///
    /// - note: RU only :)
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    public var например: Maker {
        get {
            return self
        }
    }
    
    ///	ROFL semantic property.
    ///
    /// - note: RU only :)
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    public var по_сути: Maker {
        get {
            return self
        }
    }
    
    /// Creates edges relation for `view`.
    ///
    /// - parameter view: The view, against which sets relation.
    /// - parameter insets: The insets for setting relations with `view`. `UIEdgeInsets.zero` - default insets.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func equal(to view: UIView, insets: UIEdgeInsets = .zero) -> Maker {
       
        return  top(to: view.nui_top, inset: insets.top)
                .left(to: view.nui_left, inset: insets.left)
                .bottom(to: view.nui_bottom, inset: insets.bottom)
                .right(to: view.nui_right, inset: insets.right)
    }
    
    /// Creates edges relation with optional parameters.
    ///
    /// It's useful method for configure some side relations in short form.
    ///
    /// ```
    /// Instead of writing 
    ///     maker.top(10).bottom(10).and.left(10)
    /// just write 
    ///     maker.edges(top:10, left:10, bottom:10) - it's more elegant.
    /// ```
    ///
    /// - parameter top:    The top inset relation relatively superview.
    /// - parameter left:   The left inset relation relatively superview.
    /// - parameter bottom: The bottom inset relation relatively superview.
    /// - parameter right:  The right inset relation relatively superview.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func edges(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) -> Maker {
        
        return apply(self.top, top).apply(self.left, left).apply(self.bottom, bottom).apply(self.right, right)
    }
    
    private func apply(_ f: ((UIView?, CGFloat) -> Maker), _ inset: CGFloat?) -> Maker {
        
        return (inset != nil) ? f(nil, inset!) : self
    }
    
    //MARK: High priority
    
    /// Installs constant width for current view.
    ///
    /// - parameter width:    The width for view.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func width(_ width: CGFloat) -> Maker {
        
        let handler = { [unowned self] in
            self.newRect.setValue(width, forRelation: .width)
        }
        handlers.append((.high, handler))
        relationParameters.append((.width, width))
        return self
    }
    
    /// Creates width relation relatively another view.
    ///
    /// Uses this method when you want that your view's width equals to another view's height with some multiplier, for example.
    ///
    /// - note: You can not use this method with other relations except for `nui_width` and `nui_height`.
    ///
    /// ``` 
    ///     maker.width(to: view.nui_height, multiplier: 0.5)
    /// ```
    ///
    /// - parameter view:       The view on which you set relation.
    /// - parameter multiplier: The multiplier for views relation. 1 - default multiplier value.
    ///
    /// - returns: `Maker` instance for chaining relations.

    @discardableResult public func width(to view: UIView, multiplier: CGFloat = 1.0) -> Maker {
    
        return checkRelationType(for: view) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                if relationView != self.view {
                    let width = self.relationSize(view: relationView, relationType: relationType) * multiplier
                    self.newRect.setValue(width, forRelation: .width)
                }
                else {
                    if let heightParameters = self.relationParameters(relationType: .height) {
                        
                        let width = heightParameters.argument as! CGFloat
                        self.newRect.setValue(width * multiplier, forRelation: .width)
                    }
                    else if let heightToParameters = self.relationParameters(relationType: .heightTo) {

                        let (tempView, tempMultiplier, tempRelationType) = heightToParameters.argument as! (UIView, CGFloat, RelationType)
                        let width = self.relationSize(view: tempView, relationType: tempRelationType) * (tempMultiplier * multiplier)
                        self.newRect.setValue(width, forRelation: .width)
                    }
                    else {
                        guard let topParameters = self.relationParameters(relationType: .top), let bottomParameters = self.relationParameters(relationType: .bottom) else {
                            return
                        }
                        
                        let (topView, topInset, topRelationType) = topParameters.argument as! (UIView, CGFloat, RelationType)
                        let (bottomView, bottomInset, bottomRelationType) = bottomParameters.argument as! (UIView, CGFloat, RelationType)

                        let topViewY = self.convertedValue(relationType: topRelationType, forView: topView) + topInset
                        let bottomViewY = self.convertedValue(relationType: bottomRelationType, forView: bottomView) - bottomInset
                        
                        self.newRect.setValue((bottomViewY - topViewY)*multiplier, forRelation: .width)
                    }
                }
            }
            self.handlers.append((.high, handler))
            self.relationParameters.append((.widthTo, (relationView, multiplier, relationType)))
        }
    }
    
    /// Installs constant height for current view.
    ///
    /// - parameter height: The height for view.
    ///
    /// - returns: `Maker` instance for chaining relations.

    @discardableResult public func height(_ height: CGFloat) -> Maker {
        
        let handler = { [unowned self] in
            self.newRect.setValue(height, forRelation: .height)
        }
        handlers.append((.high, handler))
        relationParameters.append((.height, height))
        return self
    }
    
    /// Creates height relation relatively another view.
    ///
    /// Uses this method when you want that your view's height equals to another view's width with some multiplier, for example.
    ///
    /// - note: You can not use this method with other relations except for `nui_width` and `nui_height`.
    ///
    /// ```
    ///     maker.width(to: view.nui_height, multiplier: 0.5)
    /// ```
    ///
    /// - parameter view:       The view on which you set relation.
    /// - parameter multiplier: The multiplier for views relation. 1 - default multiplier value.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func height(to view: UIView, multiplier: CGFloat = 1.0) -> Maker {
        
        return checkRelationType(for: view) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                if relationView != self.view {
                    let height = self.relationSize(view: relationView, relationType: relationType) * multiplier
                    self.newRect.setValue(height, forRelation: .height)
                }
                else {
                    if let widthParameters = self.relationParameters(relationType: .width) {
                        
                        let height = widthParameters.argument as! CGFloat
                        self.newRect.setValue(height * multiplier, forRelation: .height)
                    }
                    else if let widthToParameters = self.relationParameters(relationType: .widthTo) {
                        
                        let (tempView, tempMultiplier, tempRelationType) = widthToParameters.argument as! (UIView, CGFloat, RelationType)
                        let height = self.relationSize(view: tempView, relationType: tempRelationType) * (tempMultiplier * multiplier)
                        self.newRect.setValue(height, forRelation: .height)
                    }
                    else {
                        guard let leftParameters = self.relationParameters(relationType: .left), let rightParameters = self.relationParameters(relationType: .right) else {
                            return
                        }
                        
                        let (leftView, leftInset, leftRelationType) = leftParameters.argument as! (UIView, CGFloat, RelationType)
                        let (rightView, rightInset, rightRelationType) = rightParameters.argument as! (UIView, CGFloat, RelationType)
                        
                        let leftViewX = self.convertedValue(relationType: leftRelationType, forView: leftView) + leftInset
                        let rightViewX = self.convertedValue(relationType: rightRelationType, forView: rightView) - rightInset
                        
                        self.newRect.setValue((rightViewX - leftViewX)*multiplier, forRelation: .height)
                    }
                }
            }
            self.handlers.append((.high, handler))
            self.relationParameters.append((.heightTo, (relationView, multiplier, relationType)))
        }
    }
    
    /// Installs constant width and height at the same time.
    ///
    /// - parameter width:  The width for view.
    /// - parameter height: The height for view.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func size(width: CGFloat, height: CGFloat) -> Maker {
        
        return self.width(width).height(height)
    }
    
    /// Creates left relation.
    ///
    /// Use this method when you want to join left side of current view with some horizontal side of another view.
    ///
    /// - note: It's important to specify view relation. E.g `nui_left`, `nui_centerX` and `nui_right`.
    ///
    /// ```
    /// Correct:
    ///     maker.left(to: view.nui_right)
    /// Incorrect:
    ///     maker.left(to: view)
    /// ```
    ///
    /// - parameter view:  The view on which you set left relation. Superview - default view.
    /// - parameter inset: The inset for additional space between views. 0 - default value.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func left(to view: UIView? = nil, inset: CGFloat = 0.0) -> Maker {

        return checkRelationType(for: view ?? self.view.superview?.nui_left) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                let x = self.convertedValue(relationType: relationType, forView: relationView) + inset
                self.newRect.setValue(x, forRelation: .left)
            }
            self.handlers.append((.high, handler))
            self.relationParameters.append((.left, (relationView, inset, relationType)))
        }
    }
    
    /// Creates top relation.
    ///
    /// Use this method when you want to join top side of current view with some vertical side of another view.
    ///
    /// - note: It's important to specify view relation. E.g `nui_top`, `nui_centerY` and `nui_bottom`.
    ///
    /// ```
    /// Correct:
    ///     maker.top(to: view.nui_bottom)
    /// Incorrect:
    ///     maker.top(to: view)
    /// ```
    ///
    /// - parameter view:  The view on which you set top relation. Superview - default view.
    /// - parameter inset: The inset for additional space between views. 0 - default value.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func top(to view: UIView? = nil, inset: CGFloat = 0.0) -> Maker {

        return checkRelationType(for: view ?? self.view.superview?.nui_top) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                let y = self.convertedValue(relationType: relationType, forView: relationView) + inset
                self.newRect.setValue(y, forRelation: .top)
            }
            self.handlers.append((.high, handler))
            self.relationParameters.append((.top, (relationView, inset, relationType)))
        }
    }
    
    /// Creates сontainer relation.
    ///
    /// Use this method when you want to set `width` and `height` by wrapping all subviews.
    ///
    /// - note: First, you should configure all subviews and then call this method for `container view`.
    /// - note: Also important to understand, that it's not correct to call 'left' and 'right' relations together by subview, because
    ///         `container` sets width relatively width of subview and here is some ambiguous.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func container() -> Maker {
        
        var frame = CGRect.zero
        for subview in self.view.subviews {
            frame = frame.union(subview.frame)
        }
        setHighPriorityValue(frame.width, forRelation: .width)
        setHighPriorityValue(frame.height, forRelation: .height)
        return self
    }

    /// Resizes the current view so it just encloses its subviews.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func sizeToFit() -> Maker {
        
        view.sizeToFit()
        setHighPriorityValue(view.bounds.width, forRelation: .width)
        setHighPriorityValue(view.bounds.height, forRelation: .height)
        return self
    }
    
    /// Resizes and moves the receiver view so it just encloses its subviews only for height.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func heightToFit() -> Maker {
        
        view.sizeToFit()
        setHighPriorityValue(view.bounds.height, forRelation: .height)
        return self
    }
    
    /// Resizes and moves the receiver view so it just encloses its subviews only for width.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func widthToFit() -> Maker {
        
        view.sizeToFit()
        setHighPriorityValue(view.bounds.width, forRelation: .width)
        return self
    }
    
    /// Calculate the size that best fits the specified size.
    ///
    /// ```
    ///     maker.sizeThatFits(size: CGSize(width: cell.frame.width, height: cell.frame.height)
    /// ```
    /// - parameter size: The size for best-fitting.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func sizeThatFits(size: CGSize) -> Maker {
        
        let fitSize = view.sizeThatFits(size)
        let width = min(size.width, fitSize.width)
        let height = min(size.height, fitSize.height)
        setHighPriorityValue(width, forRelation: .width)
        setHighPriorityValue(height, forRelation: .height)
        return self
    }
    
    //MARK: Middle priority
    
    /// Creates edges relation for superview.
    ///
    /// - parameter insets: The insets for setting relations for superview. `UIEdgeInsets.zero` - default insets.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func edges(insets: UIEdgeInsets = .zero) -> Maker {
        
        assert(self.view.superview != nil, "Can not create realtions without superview.")
        
        let handler = { [unowned self] in
            let width = self.view.superview!.bounds.width - (insets.left + insets.right)
            let height = self.view.superview!.bounds.height - (insets.left + insets.right)
            let frame = CGRect(x: insets.left, y: insets.top, width: width, height: height)
            self.newRect = frame
        }
        self.handlers.append((.middle, handler))
        return self
    }
    
    /// Creates bottom relation.
    ///
    /// Use this method when you want to join bottom side of current view with some vertical side of another view.
    ///
    /// - note: It's important to specify view relation. E.g `nui_top`, `nui_centerY` and `nui_bottom`.
    ///
    /// ```
    /// Correct:
    ///     maker.bottom(to: view.nui_bottom)
    /// Incorrect:
    ///     maker.bottom(to: view)
    /// ```
    ///
    /// - parameter view:     The view on which you set top relation. Superview - default view.
    /// - parameter inset:    The inset for additional space between views. 0 - default value.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func bottom(to view: UIView? = nil, inset: CGFloat = 0.0) -> Maker {
        
        return checkRelationType(for: view ?? self.view.superview?.nui_bottom) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                if self.isExistsRelationParameters(relationType: .top) {
                    let height = fabs(self.newRect.minY - self.convertedValue(relationType: relationType, forView: relationView)) - inset
                    self.newRect.setValue(height, forRelation: .height)
                }
                else {
                    let y = self.convertedValue(relationType: relationType, forView: relationView) - inset - self.newRect.height
                    self.newRect.setValue(y, forRelation: .top)
                }
            }
            self.handlers.append((.middle, handler))
            self.relationParameters.append((.bottom, (relationView, inset, relationType)))
        }
    }
    
    /// Creates right relation.
    ///
    /// Use this method when you want to join right side of current view with some horizontal side of another view.
    ///
    /// - note: It's important to specify view relation. E.g `nui_left`, `nui_centerX` and `nui_right`.
    ///
    /// ```
    /// Correct:
    ///     maker.right(to: view.nui_right)
    /// Incorrect:
    ///     maker.right(to: view)
    /// ```
    ///
    /// - parameter view:     The view on which you set left relation. Superview - default view.
    /// - parameter inset:    The inset for additional space between views. 0 - default value.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func right(to view: UIView? = nil, inset: CGFloat = 0.0) -> Maker {
        
        return checkRelationType(for: view ?? self.view.superview?.nui_right) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                if self.isExistsRelationParameters(relationType: .left) {
                    let width = fabs(self.newRect.minX - self.convertedValue(relationType: relationType, forView: relationView)) - inset
                    self.newRect.setValue(width, forRelation: .width)
                }
                else {
                    let x = self.convertedValue(relationType: relationType, forView: relationView) - inset - self.newRect.width
                    self.newRect.setValue(x, forRelation: .left)
                }
            }
            self.handlers.append((.middle, handler))
            self.relationParameters.append((.right, (relationView, inset, relationType)))
        }
    }
    
    //MARK: Low priority
    
    /// Creates centerY relation.
    ///
    /// Use this method when you want to join centerY of current view with some vertical side of another view.
    ///
    /// - note: It's important to specify view relation. E.g `nui_top`, `nui_centerY` and `nui_bottom`.
    ///
    /// ```
    /// Correct:
    ///     maker.centerY(to: view.nui_top)
    /// Incorrect:
    ///     maker.centerY(to: view)
    /// ```
    ///
    /// - parameter view:   The view on which you set centerY relation. Superview - default view.
    /// - parameter offset: Additional offset for centerY point. 0 - default value.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func centerY(to view: UIView? = nil, offset: CGFloat = 0.0) -> Maker {
        
        return checkRelationType(for: view ?? self.view.superview?.nui_centerY) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                let y = self.convertedValue(relationType: relationType, forView: relationView) - self.newRect.height/2 - offset
                self.newRect.setValue(y, forRelation: .top)
            }
            self.handlers.append((.low, handler))
        }
    }
    
    /// Creates centerX relation.
    ///
    /// Use this method when you want to join centerX of current view with some horizontal side of another view.
    ///
    /// - note: It's important to specify view relation. E.g `nui_left`, `nui_centerX` and `nui_right`.
    ///
    /// ```
    /// Correct:
    ///     maker.centerX(to: view.nui_left)
    /// Incorrect:
    ///     maker.centerX(to: view)
    /// ```
    ///
    /// - parameter view:   The view on which you set centerX relation. Superview - default view.
    /// - parameter offset: Additional offset for centerY point. 0 - default value.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func centerX(to view: UIView? = nil, offset: CGFloat = 0.0) -> Maker {
        
        return checkRelationType(for: view ?? self.view.superview?.nui_centerX) { [unowned self] relationView, relationType in
            
            let handler = { [unowned self] in
                let x = self.convertedValue(relationType: relationType, forView: relationView) - self.newRect.width/2 - offset
                self.newRect.setValue(x, forRelation: .left)
            }
            self.handlers.append((.low, handler))
        }
    }
    
    /// Just setting centerX.
    ///
    /// - parameter value: The value for setting centerX.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func setCenterX(value: CGFloat) -> Maker {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value, forRelation: .centerX)
        }
        self.handlers.append((.low, handler))
        return self
    }
    
    /// Just setting centerY.
    ///
    /// - parameter value: The value for setting centerY.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func setCenterY(value: CGFloat) -> Maker {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value, forRelation: .centerY)
        }
        self.handlers.append((.low, handler))
        return self
    }
    
    //MARK: Private

    
    private func checkRelationType(for relationView: UIView?, configurationBlock: (UIView, RelationType) -> Void) -> Maker {

        guard relationView != nil else {
            assertionFailure("Can not configure relation with not correct view.")
            return self
        }
        
        assert(relationView!.relationType != nil, "The view '\(relationView)' hasn't a relation type.")
        configurationBlock(relationView!, relationView!.relationType!)
        return self
    }

    private func setHighPriorityValue(_ value: CGFloat, forRelation type: RelationType) {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value, forRelation: type)
        }
        self.handlers.append((.high, handler))
        self.relationParameters.append((type, value))
    }
}

