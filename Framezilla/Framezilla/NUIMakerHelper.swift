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
            case .NUIRelationTypeWidth:
                frame.size.width = value
            case .NUIRelationTypeHeight:
                frame.size.height = value
            default: break
        }
        newRect = frame
    }
    
}
