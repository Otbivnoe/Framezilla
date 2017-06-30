//
//  Maker+Configurations.swift
//  Framezilla
//
//  Created by Nikita on 27/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

public typealias InstallerBlock = (Maker) -> Void

postfix operator <<
public postfix func << (view: UIView) -> Maker {
    let maker = Maker(view: view)
    maker.newRect = view.frame
    return maker
}

postfix operator >>
public postfix func >> (maker: Maker) {
    if (maker.view.nx_state as? String) == DEFAULT_STATE {
        maker.configureFrame()
    }
}

extension Maker {
    
    class func configure(view: UIView, for state: AnyHashable, with installerBlock: InstallerBlock) {
        if view.nx_state == state {
            let maker = Maker(view: view)
            
            maker.newRect = view.frame
            installerBlock(maker)
            
            maker.configureFrame()
        }
    }
    
    fileprivate func configureFrame() {
        handlers.sort {
            $0.priority.rawValue <= $1.priority.rawValue
        }
        
        for handler in handlers {
            handler.handler()
        }
        
        view.frame = newRect
    }
}
