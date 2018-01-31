//
//  UIView+Installer.swift
//  Framezilla
//
//  Created by Nikita on 27/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation
import ObjectiveC

public let DEFAULT_STATE = "DEFAULT STATE"

private var stateTypeAssociationKey: UInt8 = 0
private var nxStateTypeAssociationKey: UInt8 = 1

public extension UIView {
    
    /// Apply new configuration state without frame updating.
    ///
    /// - note: Use `DEFAULT_STATE` for setting the state to the default value.
    
    @available(*, message: "Renamed due to conflict with Objective-C library - Framer", unavailable, renamed: "nx_state")
    public var nui_state: AnyHashable {
        get {
            if let value = objc_getAssociatedObject(self, &stateTypeAssociationKey) as? AnyHashable {
                return value
            }
            else {
                return DEFAULT_STATE
            }
        }
        set {
            objc_setAssociatedObject(self, &stateTypeAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Apply new configuration state without frame updating.
    ///
    /// - note: Use `DEFAULT_STATE` for setting the state to the default value.
    
    public var nx_state: AnyHashable {
        get {
            if let value = objc_getAssociatedObject(self, &nxStateTypeAssociationKey) as? AnyHashable {
                return value
            }
            else {
                return DEFAULT_STATE
            }
        }
        set {
            objc_setAssociatedObject(self, &nxStateTypeAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIView {
    
    @available(*, deprecated, renamed: "configureFrame(state:installerBlock:)")
    public func configureFrames(state: AnyHashable = DEFAULT_STATE, installerBlock: InstallerBlock) {
        Maker.configure(view: self, for: state, installerBlock: installerBlock)
    }
    
    /// Configures frame of current view for special state.
    ///
    /// - note: When you configure frame without implicit state parameter (default value), frame configures for the `DEFAULT_STATE`.
    ///
    /// - parameter state:          The state for which you configure frame. Default value: `DEFAULT_STATE`.
    /// - parameter installerBlock: The installer block within which you can configure frame relations.
    
    public func configureFrame(state: AnyHashable = DEFAULT_STATE, installerBlock: InstallerBlock) {
        Maker.configure(view: self, for: state, installerBlock: installerBlock)
    }
    
    /// Configures frame of current view for special states.
    ///
    /// - note: Don't forget about `DEFAULT_VALUE`.
    ///
    /// - parameter states:         The states for which you configure frame.
    /// - parameter installerBlock: The installer block within which you can configure frame relations.
    
    public func configureFrame(states: [AnyHashable], installerBlock: InstallerBlock) {
        for state in states {
            Maker.configure(view: self, for: state, installerBlock: installerBlock)
        }
    }
}

public extension Sequence where Iterator.Element: UIView {
    
    /// Configures frames of the views for special state.
    ///
    /// - note: When you configure frame without implicit state parameter (default value), frame configures for the `DEFAULT_STATE`.
    ///
    /// - parameter state:          The state for which you configure frame. Default value: `DEFAULT_STATE`.
    /// - parameter installerBlock: The installer block within which you can configure frame relations.
    
    public func configureFrames(state: AnyHashable = DEFAULT_STATE, installerBlock: InstallerBlock) {
        for view in self {
            view.configureFrame(state: state, installerBlock: installerBlock)
        }
    }
    
    /// Configures frames of the views for special states.
    ///
    /// - note: Don't forget about `DEFAULT_VALUE`.
    ///
    /// - parameter states:         The states for which you configure frames.
    /// - parameter installerBlock: The installer block within which you can configure frame relations.
    
    public func configureFrames(states: [AnyHashable], installerBlock: InstallerBlock) {
        for view in self {
            view.configureFrame(states: states, installerBlock: installerBlock)
        }
    }
}

public extension Collection where Iterator.Element: UIView, Self.Index == Int, Self.IndexDistance == Int {

    /// Creates сontainer view and configures all subview within this container.
    ///
    /// Use this method when you want to set `width` and `height` by wrapping all subviews.
    ///
    /// - note: It atomatically adds all subviews to the container. Don't add subviews manually.
    /// - note: Also important to understand, that it's not correct to call 'left' and 'right' relations together by subview, because
    ///         `container` sets width relatively width of subview and here is some ambiguous.
    ///
    /// - parameter view:           The view where a container will be added.
    /// - parameter installerBlock: The installer block within which you should configure frames for all subviews.
    ///
    /// - returns: Container view.

    public func container(in view: UIView, configuration: ((UIView) -> Void)? = nil, installerBlock: () -> Void) -> UIView {
        let container: UIView
        if let superView = self.first?.superview {
            container = superView
        }
        else {
            container = UIView()
            configuration?(container)
        }
        for view in self {
            container.addSubview(view)
        }
        view.addSubview(container)
        
        installerBlock()
        container.configureFrame { maker in
            maker.container()
        }
        installerBlock()
        return container
    }
}
