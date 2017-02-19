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
    
    class func configurate(view: UIView, forState state:Int, with installerBlock: InstallerBlock) {
        
        if (view.nui_state == state) {
            let maker = Maker(view: view)
            
            maker.newRect = view.frame
            installerBlock(maker)
            
            maker.configurateFrame()
        }
    }
    
    private func configurateFrame() {
        
        handlers.sort {
            $0.priority.rawValue <= $1.priority.rawValue
        }
        
        for handler in handlers {
            handler.handler()
        }
        
        view.frame = newRect
    }
}
