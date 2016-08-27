//
//  NUIMakerHelper.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

extension NUIMaker {
    
    typealias HandlerType = () -> Void
    
    func setFrameValue(_ value: CGFloat, forRelation type: NUIRelationType) {
        
        var frame = newRect
        switch type {
            case .NUIRelationTypeWidth:  frame.size.width = value
            case .NUIRelationTypeHeight: frame.size.height = value
            default: break
        }
        newRect = frame
    }
    
    func convertedValue(relationType: NUIRelationType, forView view: UIView) -> CGFloat {
    
        let convertedRect = self.view.superview!.convert(view.frame, from: view.superview)
        
        switch relationType {
            case .NUIRelationTypeTop:        return convertedRect.minY
            case .NUIRelationTypeBottom:     return convertedRect.maxY
            case .NUIRelationTypeCenterY:    return convertedRect.midY
            case .NUIRelationTypeCenterX:    return convertedRect.midX
            case .NUIRelationTypeRight:      return convertedRect.maxX
            case .NUIRelationTypeLeft:       return convertedRect.minX
            default: return 0
        }
    }
    
}
