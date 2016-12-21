//
//  MakerHelper.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

extension Maker {

    func convertedValue(relationType: RelationType, forView view: UIView) -> CGFloat {
    
        let convertedRect = self.view.superview!.convert(view.frame, from: view.superview)
        
        switch relationType {
            case .top:        return convertedRect.minY
            case .bottom:     return convertedRect.maxY
            case .centerY:    return convertedRect.midY
            case .centerX:    return convertedRect.midX
            case .right:      return convertedRect.maxX
            case .left:       return convertedRect.minX
            default: return 0
        }
    }

    func relationSize(view: UIView, relationType: RelationType) -> CGFloat {

        switch relationType {
            case .width:  return view.bounds.width
            case .height: return view.bounds.height
            default:
                return 0
        }
    }
    
    func relationParameters(relationType: RelationType) -> RelationParametersType? {
        
        return relationParameters.filter { type, _ in type == relationType }.first
    }
    
    func isExistsRelationParameters(relationType: RelationType) -> Bool {
        
        return relationParameters(relationType: relationType) != nil
    }
}

extension CGRect {
    
    mutating func setValue(_ value: CGFloat, for type: RelationType) {
        
        var frame = self
        switch type {
            case .width:   frame.size.width = value
            case .height:  frame.size.height = value
            case .left:    frame.origin.x = value
            case .top:     frame.origin.y = value
            case .centerX: frame.origin.x = value - self.width/2;
            case .centerY: frame.origin.y = value - self.height/2;
            default: break
        }
        self = frame
    }
}
