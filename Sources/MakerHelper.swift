//
//  MakerHelper.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

fileprivate extension UIView {
    
    func contains(view: UIView) -> Bool {
        if subviews.contains(view) {
            return true
        }
        for subview in subviews {
            if subview.contains(view: view) {
                return true
            }
        }
        return false
    }
}

extension Maker {

    func convertedValue(for type: RelationType, with view: UIView) -> CGFloat {

        var convertedRect: CGRect {
            if let scrollView = self.view.superview as? UIScrollView {
                return CGRect(x: 0,
                              y: 0,
                              width: scrollView.contentSize.width,
                              height: scrollView.contentSize.height)
            }
            else {
                return self.view.superview!.convert(view.frame, from: view.superview)
            }
        }

        switch type {
            case .top:        return convertedRect.minY
            case .bottom:     return convertedRect.maxY
            case .centerY:    return view.contains(view: self.view) ? convertedRect.height / 2 : convertedRect.midY
            case .centerX:    return view.contains(view: self.view) ? convertedRect.width / 2 : convertedRect.midX
            case .right:      return convertedRect.maxX
            case .left:       return convertedRect.minX
            default:          return 0
        }
    }
    
    func relationSize(view: UIView, for type: RelationType) -> CGFloat {

        switch type {
            case .width:  return view.bounds.width
            case .height: return view.bounds.height
            default:      return 0
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
            case .centerX: frame.origin.x = value - width/2
            case .centerY: frame.origin.y = value - height/2
            default: break
        }
        self = frame
    }
}
