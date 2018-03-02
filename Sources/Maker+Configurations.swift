//
//  Maker+Configurations.swift
//  Framezilla
//
//  Created by Nikita on 27/08/16.
//  Copyright © 2016 Nikita. All rights reserved.
//

import Foundation

extension Maker {
    
    class func configure(view: UIView, for state: AnyHashable, installerBlock: InstallerBlock<T>) {
        if view.nx_state == state {
            let maker = Maker<T>(view: view)
            
            maker.newRect = view.frame
            installerBlock(maker)
            
            maker.configureFrame()
        }
    }
    
    func configureFrame() {
        handlers.sorted {
            $0.priority.rawValue <= $1.priority.rawValue
        }.forEach {
            $0.handler()
        }

        view.frame = newRect
    }
}
