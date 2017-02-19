//
//  UIView+Installer.swift
//  Framezilla
//
//  Created by Nikita on 27/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation
import ObjectiveC

fileprivate var STATE_DEFAULT_VALUE = "DEFAULT VALUE"
fileprivate var stateTypeAssociationKey: UInt8 = 0

public extension UIView {
    
    /// Apply new configuration state without frame updating

    public var nui_state: AnyHashable? {
        get {
            if let value = objc_getAssociatedObject(self, &stateTypeAssociationKey) as? AnyHashable {
                return value
            }
            else {
                return STATE_DEFAULT_VALUE
            }
        }
        set {
            objc_setAssociatedObject(self, &stateTypeAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIView {
    
    /// Creates and configurates Maker object for each view.
    ///
    /// - parameter state:          The state for which you configurate frame.
    /// - parameter installerBlock: The installer block within which you can configurate frame relations.
    
    public func configureFrames(state: AnyHashable = STATE_DEFAULT_VALUE, installerBlock: InstallerBlock) {

        Maker.configure(view: self, for: state, with: installerBlock)
    }
}

public extension Array where Element: UIView {
    
    /// Creates and configurates Maker object for each view.
    ///
    /// - parameter state:          The state for which you configurate frame.
    /// - parameter installerBlock: The installer block within which you can configurate frame relations.
    
    public func configureFrames(state: AnyHashable = STATE_DEFAULT_VALUE, installerBlock: InstallerBlock) {
        
        for view in self {
            Maker.configure(view: view, for: state, with: installerBlock)
        }
    }
}
