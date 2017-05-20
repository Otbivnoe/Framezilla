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

fileprivate var stateTypeAssociationKey: UInt8 = 0
fileprivate var nxStateTypeAssociationKey: UInt8 = 1

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

        Maker.configure(view: self, for: state, with: installerBlock)
    }
    
    /// Configures frame of current view for special state.
    ///
    /// - note: When you configure frame without implicit state parameter (default value), frame configures for the `DEFAULT_STATE`.
    ///
    /// - parameter state:          The state for which you configure frame. Default value: `DEFAULT_STATE`.
    /// - parameter installerBlock: The installer block within which you can configure frame relations.
    
    public func configureFrame(state: AnyHashable = DEFAULT_STATE, installerBlock: InstallerBlock) {
        
        Maker.configure(view: self, for: state, with: installerBlock)
    }
    
    /// Configures frame of current view for special states.
    ///
    /// - note: Don't forget about `DEFAULT_VALUE`.
    ///
    /// - parameter states:         The states for which you configure frame.
    /// - parameter installerBlock: The installer block within which you can configure frame relations.
    
    public func configureFrame(states: [AnyHashable], installerBlock: InstallerBlock) {
        
        for state in states {
            Maker.configure(view: self, for: state, with: installerBlock)
        }
    }
}

public extension Array where Element: UIView {
    
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
