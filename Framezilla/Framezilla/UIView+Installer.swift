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
            return objc_getAssociatedObject(self, &stateTypeAssociationKey) as! Int
        }
        set(newValue) {
            objc_setAssociatedObject(self, &stateTypeAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIView {
    
    public func configureFrames(state: Int = 0, installerBlock: InstallerBlock) {
        
        NUIMaker.configurate(view: self, forState: state, with: installerBlock)
    }
}
