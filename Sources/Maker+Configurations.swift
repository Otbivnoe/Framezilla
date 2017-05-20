//
//  Maker+Configurations.swift
//  Framezilla
//
//  Created by Nikita on 27/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

public typealias InstallerBlock = (Maker) -> Void

extension Maker {
    
    class func configure(view: UIView, for state: AnyHashable, with installerBlock: InstallerBlock) {
        
        if view.nx_state == state {
            let maker = Maker(view: view)
            
            maker.newRect = view.frame
            installerBlock(maker)
            
            maker.configureFrame()
        }
    }
    
    private func configureFrame() {
        
        handlers.sort {
            $0.priority.rawValue <= $1.priority.rawValue
        }
        
        for handler in handlers {
            handler.handler()
        }
        
        view.frame = newRect
    }
}
