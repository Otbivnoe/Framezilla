//
//  NUIMaker.swift
//  Framezilla
//
//  Created by Nikita on 26/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

//Access control
enum NUIHandlerPriority {
    case NUIHandlerPriorityTop
    case NUIHandlerPriorityMiddle
    case NUIHandlerPriorityLow
}

public final class NUIMaker {
    
    private unowned let view: UIView
    
    var handlers: [(NUIHandlerPriority, HandlerType)] = []
    var relationParameters: [(NUIRelationType, [Any])] = []
    var newRect: CGRect

    init(view: UIView) {
        self.view = view
        self.newRect = view.frame
    }
    
    public func and() -> NUIMaker {
        
        return self
    }

    //MARK: Top priority
    
    public func width(_ width: CGFloat) -> NUIMaker {
        
        let handler: HandlerType = { [unowned self] in
            self.setFrameValue(width, forRelation: .NUIRelationTypeWidth)
        }

        handlers.append((.NUIHandlerPriorityTop, handler))
        relationParameters.append((.NUIRelationTypeHeight, [width]))
        return self
    }
    
    public func height(_ height: CGFloat) -> NUIMaker {
        
        let handler: HandlerType = { [unowned self] in
            self.setFrameValue(height, forRelation: .NUIRelationTypeWidth)
        }
        
        handlers.append((.NUIHandlerPriorityTop, handler))
        relationParameters.append((.NUIRelationTypeHeight, [height]))
        return self
    }
    
    /*
    public func left(view: UIView? = nil, inset: CGFloat = 0) -> NUIMaker {
        
        let relationView = view ?? self.view
        let handler: HandlerType = { [unowned self] in
            
        }
        
        handlers.append((.NUIHandlerPriorityTop, handler))
        relationParameters.append((.NUIRelationTypeLeft, [view, inset, "relationType"]))
        return self
    }
    */
 
    //MARK: Middle priority
}
