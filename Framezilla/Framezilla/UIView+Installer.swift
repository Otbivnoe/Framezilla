//
//  UIView+Installer.swift
//  Framezilla
//
//  Created by Nikita on 27/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation
import ObjectiveC

fileprivate var stateTypeAssociationKey: UInt8 = 0

public extension UIView {
    
    /// Apply new configuration state without frame updating

    public var nui_state: Int {
        get {
            let state = objc_getAssociatedObject(self, &stateTypeAssociationKey) as? Int
            return state ?? 0
        }
        set(newValue) {
            objc_setAssociatedObject(self, &stateTypeAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIView {
    
    /// Creates and configurates NUIMaker object for each view.
    ///
    /// - parameter state:          The state for which you configurate frame.
    /// - parameter installerBlock: The installer block within which you can configurate frame relations.
    
    public func configureFrames(state: Int = 0, installerBlock: InstallerBlock) {

        NUIMaker.configurate(view: self, forState: state, with: installerBlock)
    }
}
