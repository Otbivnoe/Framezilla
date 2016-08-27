//
//  UIView+Relations.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation
import ObjectiveC

enum NUIRelationType {
    case NUIRelationTypeBottom
    case NUIRelationTypeTop
    case NUIRelationTypeLeft
    case NUIRelationTypeRight
    case NUIRelationTypeWidth
    case NUIRelationTypeHeight
    case NUIRelationTypeCenterX
    case NUIRelationTypeCenterY
}

fileprivate var relationTypeAssociationKey: UInt8 = 0

extension UIView {
    
    var relationType: NUIRelationType! {
        get {
            return objc_getAssociatedObject(self, &relationTypeAssociationKey) as! NUIRelationType
        }
        set(newValue) {
            objc_setAssociatedObject(self, &relationTypeAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
