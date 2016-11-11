//
//  UIView+Relations.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation
import ObjectiveC

enum RelationType: Int {
    case bottom
    case top
    case left
    case right
    case width
    case widthTo
    case height
    case heightTo
    case centerX
    case centerY
}

fileprivate var relationTypeAssociationKey: UInt8 = 0

extension UIView {
    
    var relationType: RelationType? {
        get {
            return objc_getAssociatedObject(self, &relationTypeAssociationKey) as? RelationType
        }
        set(newValue) {
            objc_setAssociatedObject(self, &relationTypeAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UIView {
    
    

    public var nui_width: UIView {
        get {
            relationType = .width
            return self
        }
    }
    
    public var nui_height: UIView {
        get {
            relationType = .height
            return self
        }
    }
    
    public var nui_left: UIView {
        get {
            relationType = .left
            return self
        }
    }
    
    public var nui_right: UIView {
        get {
            relationType = .right
            return self
        }
    }
    
    public var nui_top: UIView {
        get {
            relationType = .top
            return self
        }
    }
    
    public var nui_bottom: UIView {
        get {
            relationType = .bottom
            return self
        }
    }
    
    public var nui_centerX: UIView {
        get {
            relationType = .centerX
            return self
        }
    }
    
    public var nui_centerY: UIView {
        get {
            relationType = .centerY
            return self
        }
    }
}
