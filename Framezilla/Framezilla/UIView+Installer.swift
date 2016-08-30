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
    
    public func configureFrames(state: Int = 0, installerBlock: InstallerBlock) {

        assert(self.superview != nil, "Can't configure frame for view without superview")
        NUIMaker.configurate(view: self, forState: state, with: installerBlock)
    }
}
