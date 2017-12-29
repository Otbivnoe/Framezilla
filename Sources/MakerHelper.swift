//
//  MakerHelper.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

fileprivate extension UIView {
    
    func contains(_ view: UIView) -> Bool {
        if subviews.contains(view) {
            return true
        }
        for subview in subviews {
            if subview.contains(view) {
                return true
            }
        }
        return false
    }
}

extension Maker {

    func convertedValue(for type: RelationType, with view: UIView) -> CGFloat {
        var rect: CGRect {
            if let superview = self.view.superview, superview === view {
                return CGRect(origin: .zero, size: superview.bounds.size)
            }

            if let supervew = self.view.superview {
                return supervew.convert(view.frame, from: view.superview)
            }
            assertionFailure("Can't configure a frame for view: \(self.view) without superview.")
            return .zero
        }

        var convertedRect = rect
        if let superScrollView = self.view.superview as? UIScrollView, view is UIScrollView, superScrollView.contentSize != .zero {
            convertedRect.size.width = superScrollView.contentSize.width
            convertedRect.size.height = superScrollView.contentSize.height
        }

        switch type {
        case .top:        return convertedRect.minY
        case .bottom:     return convertedRect.maxY
        case .centerY:    return view.contains(self.view) ? convertedRect.height / 2 : convertedRect.midY
        case .centerX:    return view.contains(self.view) ? convertedRect.width / 2 : convertedRect.midX
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
}

extension Maker {

    var height: CGFloat? {
        if let parameter = self.heightParameter {
            return parameter.value
        }
        else if let parameter = self.heightToParameter {
            let width = self.relationSize(view: parameter.view, for: parameter.relationType) * parameter.value
            return width
        }
        else if let topParameter = self.topParameter, let bottomParameter = self.bottomParameter {
            let topViewY = self.convertedValue(for: topParameter.relationType, with: topParameter.view) + topParameter.value
            let bottomViewY = self.convertedValue(for: bottomParameter.relationType, with: bottomParameter.view) - bottomParameter.value

            return bottomViewY - topViewY
        }
        return nil
    }

    var width: CGFloat? {
        if let parameter = self.widthParameter {
            return parameter.value
        }
        else if let parameter = self.widthToParameter {
            let height = self.relationSize(view: parameter.view, for: parameter.relationType) * parameter.value
            return height
        }
        else if let leftParameter = self.leftParameter, let rightParameter = self.rightParameter {
            let leftViewX = self.convertedValue(for: leftParameter.relationType, with: leftParameter.view) + leftParameter.value
            let rightViewX = self.convertedValue(for: rightParameter.relationType, with: rightParameter.view) - rightParameter.value

            return rightViewX - leftViewX
        }
        return nil
    }
}
