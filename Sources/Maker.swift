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

    init(view: UIView) {
        self.view = view
        self.newRect = view.frame
    }
    
    // MARK: Additions
    
    ///	Optional semantic property for improvements readability.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    public var and: Maker {
        return self
    }

    /// Creates edge relations.
    ///
    /// - parameter view:   The view, against which sets relations.
    /// - parameter insets: The insets for setting relations with `view`. Default value: `UIEdgeInsets.zero`.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func equal(to view: UIView, insets: UIEdgeInsets = .zero) -> Maker {

        let topView = RelationView<VerticalRelation>(view: view, relation: .top)
        let leftView = RelationView<HorizontalRelation>(view: view, relation: .left)
        let bottomView = RelationView<VerticalRelation>(view: view, relation: .bottom)
        let rightView = RelationView<HorizontalRelation>(view: view, relation: .right)
        
        return  top(to: topView, inset: insets.top)
                .left(to: leftView, inset: insets.left)
                .bottom(to: bottomView, inset: insets.bottom)
                .right(to: rightView, inset: insets.right)
    }
    
    /// Creates edge relations.
    ///
    /// It's useful method for configure some side relations in short form.
    ///
    /// ```
    /// Instead of writing:
    ///     maker.top(10).bottom(10).and.left(10)
    /// just write:
    ///     maker.edges(top:10, left:10, bottom:10) - it's more elegant.
    /// ```
    ///
    /// - parameter top:    The top inset relation relatively superview.
    /// - parameter left:   The left inset relation relatively superview.
    /// - parameter bottom: The bottom inset relation relatively superview.
    /// - parameter right:  The right inset relation relatively superview.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func edges(top: Number? = nil, left: Number? = nil, bottom: Number? = nil, right: Number? = nil) -> Maker {
        
        return apply(self.top, top).apply(self.left, left).apply(self.bottom, bottom).apply(self.right, right)
    }
    
    private func apply(_ f: ((Number) -> Maker), _ inset: Number?) -> Maker {
        
        return (inset != nil) ? f(inset!) : self
    }
    
    // MARK: High priority
    
    /// Installs constant width for current view.
    ///
    /// - parameter width: The width for view.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func width(_ width: Number) -> Maker {
        
        let handler = { [unowned self] in
            self.newRect.setValue(width.value, for: .width)
        }
        handlers.append((.high, handler))
        relationParameters.append((.width, width.value))
        return self
    }
    
    /// Creates width relation relatively another view = Aspect ration.
    ///
    /// Use this method when you want that your view's width equals to another view's height with some multiplier, for example.
    ///
    /// - note: You can not use this method with other relations except for `nui_width` and `nui_height`.
    ///
    /// - parameter relationView:   The view on which you set relation.
    /// - parameter multiplier:     The multiplier for views relation. Default multiplier value: 1.
    ///
    /// - returns: `Maker` instance for chaining relations.

    @discardableResult public func width(to relationView: RelationView<SizeRelation>, multiplier: Number = 1.0) -> Maker {
    
        let view = relationView.view
        let relationType = relationView.relationType
        
        let handler = { [unowned self] in
            if view != self.view {
                let width = self.relationSize(view: view, for: relationType) * multiplier.value
                self.newRect.setValue(width, for: .width)
            }
            else {
                if let heightParameters = self.relationParameters(relationType: .height) {
                    // TODO: Avoid force cast
                    // swiftlint:disable force_cast
                    let width = heightParameters.argument as! CGFloat
                    self.newRect.setValue(width * multiplier.value, for: .width)
                }
                else if let heightToParameters = self.relationParameters(relationType: .heightTo) {

                    let (tempView, tempMultiplier, tempRelationType) = heightToParameters.argument as! (UIView, CGFloat, RelationType)
                    let width = self.relationSize(view: tempView, for: tempRelationType) * (tempMultiplier * multiplier.value)
                    self.newRect.setValue(width, for: .width)
                }
                else {
                    guard let topParameters = self.relationParameters(relationType: .top), let bottomParameters = self.relationParameters(relationType: .bottom) else {
                        return
                    }
                    
                    let (topView, topInset, topRelationType) = topParameters.argument as! (UIView, CGFloat, RelationType)
                    let (bottomView, bottomInset, bottomRelationType) = bottomParameters.argument as! (UIView, CGFloat, RelationType)
                    // swiftlint:enable force_cast
                    
                    let topViewY = self.convertedValue(for: topRelationType, with: topView) + topInset
                    let bottomViewY = self.convertedValue(for: bottomRelationType, with: bottomView) - bottomInset
                    
                    self.newRect.setValue((bottomViewY - topViewY)*multiplier.value, for: .width)
                }
            }
        }
        handlers.append((.high, handler))
        relationParameters.append((.widthTo, (view, multiplier.value, relationType)))
        return self
        
    }
    
    /// Installs constant height for current view.
    ///
    /// - parameter height: The height for view.
    ///
    /// - returns: `Maker` instance for chaining relations.

    @discardableResult public func height(_ height: Number) -> Maker {
        
        let handler = { [unowned self] in
            self.newRect.setValue(height.value, for: .height)
        }
        handlers.append((.high, handler))
        relationParameters.append((.height, height.value))
        return self
    }
    
    /// Creates height relation relatively another view = Aspect ration.
    ///
    /// Use this method when you want that your view's height equals to another view's width with some multiplier, for example.
    ///
    /// - note: You can not use this method with other relations except for `nui_width` and `nui_height`.
    ///
    /// - parameter relationView:   The view on which you set relation.
    /// - parameter multiplier:     The multiplier for views relation. Default multiplier value: 1.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func height(to relationView: RelationView<SizeRelation>, multiplier: Number = 1.0) -> Maker {
        
        let view = relationView.view
        let relationType = relationView.relationType
        
        let handler = { [unowned self] in
            if view != self.view {
                let height = self.relationSize(view: view, for: relationType) * multiplier.value
                self.newRect.setValue(height, for: .height)
            }
            else {
                if let widthParameters = self.relationParameters(relationType: .width) {
                    // swiftlint:disable force_cast
                    let height = widthParameters.argument as! CGFloat
                    self.newRect.setValue(height * multiplier.value, for: .height)
                }
                else if let widthToParameters = self.relationParameters(relationType: .widthTo) {
                    
                    let (tempView, tempMultiplier, tempRelationType) = widthToParameters.argument as! (UIView, CGFloat, RelationType)
                    let height = self.relationSize(view: tempView, for: tempRelationType) * (tempMultiplier * multiplier.value)
                    self.newRect.setValue(height, for: .height)
                }
                else {
                    guard let leftParameters = self.relationParameters(relationType: .left), let rightParameters = self.relationParameters(relationType: .right) else {
                        return
                    }
                    
                    let (leftView, leftInset, leftRelationType) = leftParameters.argument as! (UIView, CGFloat, RelationType)
                    let (rightView, rightInset, rightRelationType) = rightParameters.argument as! (UIView, CGFloat, RelationType)
                    // swiftlint:enable force_cast
                    let leftViewX = self.convertedValue(for: leftRelationType, with: leftView) + leftInset
                    let rightViewX = self.convertedValue(for: rightRelationType, with: rightView) - rightInset
                    
                    self.newRect.setValue((rightViewX - leftViewX)*multiplier.value, for: .height)
                }
            }
        }
        handlers.append((.high, handler))
        relationParameters.append((.heightTo, (view, multiplier.value, relationType)))
        return self
    }
    
    /// Installs constant width and height at the same time.
    ///
    /// - parameter width:  The width for view.
    /// - parameter height: The height for view.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func size(width: Number, height: Number) -> Maker {
        
        return self.width(width).height(height)
    }

    /// Creates left relation to superview.
    ///
    /// Use this method when you want to join left side of current view with left side of superview.
    ///
    /// - parameter inset: The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func left(inset: Number = 0.0) -> Maker {
        guard let superview = view.superview else {
            assertionFailure("Can not configure left relation to superview without superview.")
            return self
        }
        return left(to: RelationView(view: superview, relation: .left), inset: inset)
    }

    /// Creates left relation.
    ///
    /// Use this method when you want to join left side of current view with some horizontal side of another view.
    ///
    /// - note: You can not use this method with other relations except for `nui_left`, `nui_centerX` and `nui_right`.
    ///
    /// - parameter relationView:   The view on which you set left relation.
    /// - parameter inset:          The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func left(to relationView: RelationView<HorizontalRelation>, inset: Number = 0.0) -> Maker {
       
        let view = relationView.view
        let type = relationView.relationType

        let handler = { [unowned self] in
            let x = self.convertedValue(for: type, with: view) + inset.value
            self.newRect.setValue(x, for: .left)
        }
        handlers.append((.high, handler))
        relationParameters.append((.left, (view, inset.value, type)))
        return self
    }
    
    /// Creates top relation to superview.
    ///
    /// Use this method when you want to join top side of current view with top side of superview.
    ///
    /// - parameter inset: The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func top(inset: Number = 0.0) -> Maker {
        guard let superview = view.superview else {
            assertionFailure("Can not configure top relation to superview without superview.")
            return self
        }
        return top(to: RelationView(view: superview, relation: .top), inset: inset.value)
    }
    
    /// Creates top relation.
    ///
    /// Use this method when you want to join top side of current view with some vertical side of another view.
    ///
    /// - note: You can not use this method with other relations except for `nui_top`, `nui_centerY` and `nui_bottom`.
    ///
    /// - parameter relationView:  The view on which you set top relation.
    /// - parameter inset:         The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func top(to relationView: RelationView<VerticalRelation>, inset: Number = 0.0) -> Maker {
        
        let view = relationView.view
        let type = relationView.relationType
        
        let handler = { [unowned self] in
            let y = self.convertedValue(for: type, with: view) + inset.value
            self.newRect.setValue(y, for: .top)
        }
        handlers.append((.high, handler))
        relationParameters.append((.top, (view, inset.value, type)))
        return self
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
        for subview in view.subviews {
            frame = frame.union(subview.frame)
        }
        setHighPriorityValue(frame.width, for: .width)
        setHighPriorityValue(frame.height, for: .height)
        return self
    }

    /// Resizes the current view so it just encloses its subviews.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func sizeToFit() -> Maker {
        
        view.sizeToFit()
        setHighPriorityValue(view.bounds.width, for: .width)
        setHighPriorityValue(view.bounds.height, for: .height)
        return self
    }
    
    /// Resizes and moves the receiver view so it just encloses its subviews only for height.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func heightToFit() -> Maker {
        
        view.sizeToFit()
        setHighPriorityValue(view.bounds.height, for: .height)
        return self
    }
    
    /// Resizes and moves the receiver view so it just encloses its subviews only for width.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func widthToFit() -> Maker {
        
        view.sizeToFit()
        setHighPriorityValue(view.bounds.width, for: .width)
        return self
    }
    
    /// Calculates the size that best fits the specified size.
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
        setHighPriorityValue(width, for: .width)
        setHighPriorityValue(height, for: .height)
        return self
    }
    
    // MARK: Middle priority
    
    /// Creates margin relation for superview.
    ///
    /// - parameter inset: The inset for setting top, left, bottom and right relations for superview.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func margin(_ inset: Number) -> Maker {
        
        let inset = inset.value
        return edges(insets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }
    
    /// Creates edge relations for superview.
    ///
    /// - parameter insets: The insets for setting relations for superview.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func edges(insets: UIEdgeInsets) -> Maker {
        
        guard let superview = view.superview else {
            assertionFailure("Can not create edge relations without superview.")
            return self
        }
        
        let handler = { [unowned self, unowned superview] in
            let width = superview.bounds.width - (insets.left + insets.right)
            let height = superview.bounds.height - (insets.top + insets.bottom)
            let frame = CGRect(x: insets.left, y: insets.top, width: width, height: height)
            self.newRect = frame
        }
        handlers.append((.middle, handler))
        return self
    }
    
    /// Creates bottom relation to superview.
    ///
    /// Use this method when you want to join bottom side of current view with bottom side of superview.
    ///
    /// - parameter inset: The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func bottom(inset: Number = 0.0) -> Maker {
        guard let superview = view.superview else {
            assertionFailure("Can not configure bottom relation to superview without superview.")
            return self
        }
        return bottom(to: RelationView(view: superview, relation: .bottom), inset: inset)
    }
    
    /// Creates bottom relation.
    ///
    /// Use this method when you want to join bottom side of current view with some vertical side of another view.
    ///
    /// - note: You can not use this method with other relations except for `nui_top`, `nui_centerY` and `nui_bottom`.
    ///
    /// - parameter relationView:   The view on which you set bottom relation.
    /// - parameter inset:          The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func bottom(to relationView: RelationView<VerticalRelation>, inset: Number = 0.0) -> Maker {

        let view = relationView.view
        let type = relationView.relationType
        
        let handler = { [unowned self] in
            if self.isExistsRelationParameters(relationType: .top) {
                let height = fabs(self.newRect.minY - self.convertedValue(for: type, with: view)) - inset.value
                self.newRect.setValue(height, for: .height)
            }
            else {
                let y = self.convertedValue(for: type, with: view) - inset.value - self.newRect.height
                self.newRect.setValue(y, for: .top)
            }
        }
        handlers.append((.middle, handler))
        relationParameters.append((.bottom, (view, inset.value, type)))
        return self
    }
    
    /// Creates right relation to superview.
    ///
    /// Use this method when you want to join right side of current view with right side of superview.
    ///
    /// - parameter inset: The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func right(inset: Number = 0.0) -> Maker {
        guard let superview = view.superview else {
            assertionFailure("Can not configure right relation to superview without superview.")
            return self
        }
        return right(to: RelationView(view: superview, relation: .right), inset: inset.value)
    }
    
    /// Creates right relation.
    ///
    /// Use this method when you want to join right side of current view with some horizontal side of another view.
    ///
    /// - note: You can not use this method with other relations except for `nui_left`, `nui_centerX` and `nui_right`.
    //
    /// - parameter relationView:     The view on which you set right relation.
    /// - parameter inset:            The inset for additional space between views. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func right(to relationView: RelationView<HorizontalRelation>, inset: Number = 0.0) -> Maker {
        
        let view = relationView.view
        let type = relationView.relationType
        
        let handler = { [unowned self] in
            if self.isExistsRelationParameters(relationType: .left) {
                let width = fabs(self.newRect.minX - self.convertedValue(for: type, with: view)) - inset.value
                self.newRect.setValue(width, for: .width)
            }
            else {
                let x = self.convertedValue(for: type, with: view) - inset.value - self.newRect.width
                self.newRect.setValue(x, for: .left)
            }
        }
        handlers.append((.middle, handler))
        relationParameters.append((.right, (view, inset.value, type)))
        return self
    }
    
    // MARK: Low priority
    
    /// Creates center relation to superview.
    ///
    /// Use this method when you want to center view by both axis relativity superview.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func center() -> Maker {
        guard let superview = view.superview else {
            assertionFailure("Can not configure center relation to superview without superview.")
            return self
        }
        return center(to: superview)
    }
    
    /// Creates center relation.
    ///
    /// Use this method when you want to center view by both axis relativity another view.
    ///
    /// - parameter view: The view on which you set center relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func center(to view: UIView) -> Maker {
        return centerX(to: RelationView<HorizontalRelation>(view: view, relation: .centerX))
                .centerY(to: RelationView<VerticalRelation>(view: view, relation: .centerY))
    }
    
    /// Creates centerY relation.
    ///
    /// Use this method when you want to join centerY of current view with centerY of superview.
    ///
    /// - parameter offset: Additional offset for centerY point. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func centerY(offset: Number = 0.0) -> Maker {
        guard let superview = view.superview else {
            assertionFailure("Can not configure centerY relation to superview without superview.")
            return self
        }
        return centerY(to: RelationView(view: superview, relation: .centerY), offset: offset.value)
    }
    
    /// Creates centerY relation.
    ///
    /// Use this method when you want to join centerY of current view with some vertical side of another view.
    ///
    /// - note: You can not use this method with other relations except for `nui_top`, `nui_centerY` and `nui_bottom`.
    ///
    /// - parameter relationView:   The view on which you set centerY relation.
    /// - parameter offset:         Additional offset for centerY point. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func centerY(to relationView: RelationView<VerticalRelation>, offset: Number = 0.0) -> Maker {
 
        let view = relationView.view
        let type = relationView.relationType
        
        let handler = { [unowned self] in
            let y = self.convertedValue(for: type, with: view) - self.newRect.height/2 - offset.value
            self.newRect.setValue(y, for: .top)
        }
        handlers.append((.low, handler))
        return self
    }
    
    /// Creates centerY relation between two views.
    ///
    /// Use this method when you want to configure centerY point between two following views.
    ///
    /// - parameter view1: The first view between which you set `centerY` relation.
    /// - parameter view2: The second view between which you set `centerY` relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func centerY(between view1: UIView, _ view2: UIView) -> Maker {

        let handler = { [unowned self] in
            let bottomView = view1.frame.minY > view2.frame.minY ? view1 : view2
            let topView = bottomView === view1 ? view2 : view1
            
            let topY = self.convertedValue(for: .bottom, with: topView)
            let bottomY = self.convertedValue(for: .top, with: bottomView)
            
            let y = bottomY - (bottomY - topY)/2 - self.newRect.height/2
            self.newRect.setValue(y, for: .top)
        }
        handlers.append((.low, handler))
        return self
    }
    
    /// Creates centerX relation to superview.
    ///
    /// Use this method when you want to join centerX of current view with centerX of superview.
    ///
    /// - parameter offset: Additional offset for centerX point. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func centerX(offset: Number = 0.0) -> Maker {
        guard let superview = view.superview else {
            assertionFailure("Can not configure centerX relation to superview without superview.")
            return self
        }
        return centerX(to: RelationView(view: superview, relation: .centerX), offset: offset.value)
    }
    
    /// Creates centerX relation.
    ///
    /// Use this method when you want to join centerX of current view with some horizontal side of another view.
    ///
    /// - note: You can not use this method with other relations except for `nui_left`, `nui_centerX` and `nui_right`.
    ///
    /// - parameter relationView:   The view on which you set centerX relation.
    /// - parameter offset:         Additional offset for centerX point. Default value: 0.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func centerX(to relationView: RelationView<HorizontalRelation>, offset: Number = 0.0) -> Maker {

        let view = relationView.view
        let type = relationView.relationType
        
        let handler = { [unowned self] in
            let x = self.convertedValue(for: type, with: view) - self.newRect.width/2 - offset.value
            self.newRect.setValue(x, for: .left)
        }
        handlers.append((.low, handler))
        return self
    }
    
    /// Creates centerX relation between two views.
    ///
    /// Use this method when you want to configure centerX point between two following views.
    ///
    /// - parameter view1: The first view between which you set `centerX` relation.
    /// - parameter view2: The second view between which you set `centerX` relation.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func centerX(between view1: UIView, _ view2: UIView) -> Maker {
        
        let handler = { [unowned self] in
            let rightView = view1.frame.minX > view2.frame.minX ? view1 : view2
            let leftView = rightView === view1 ? view2 : view1
            
            let leftX = self.convertedValue(for: .right, with: leftView)
            let rightX = self.convertedValue(for: .left, with: rightView)
            
            let x = rightX - (rightX - leftX)/2 - self.newRect.width/2
            self.newRect.setValue(x, for: .left)
        }
        handlers.append((.low, handler))
        return self
    }
    
    /// Just setting centerX.
    ///
    /// - parameter value: The value for setting centerX.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func setCenterX(value: Number) -> Maker {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value.value, for: .centerX)
        }
        handlers.append((.low, handler))
        return self
    }
    
    /// Just setting centerY.
    ///
    /// - parameter value: The value for setting centerY.
    ///
    /// - returns: `Maker` instance for chaining relations.
    
    @discardableResult public func setCenterY(value: Number) -> Maker {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value.value, for: .centerY)
        }
        handlers.append((.low, handler))
        return self
    }
    
    // MARK: Private

    private func setHighPriorityValue(_ value: CGFloat, for type: RelationType) {
        
        let handler = { [unowned self] in
            self.newRect.setValue(value, for: type)
        }
        handlers.append((.high, handler))
        relationParameters.append((type, value))
    }
}
