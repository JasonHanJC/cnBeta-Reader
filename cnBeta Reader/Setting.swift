//
//  Setting.swift
//  cnBeta-Reader
//
//  Created by Juncheng Han on 12/28/16.
//  Copyright © 2016 JasonH. All rights reserved.
//

import UIKit

enum SettingNames: String {
    case cancel = "Cancel"
    case share = "Share"
    case openInBrowser = "Open in browser"
}

class Setting: NSObject {
    let name: SettingNames
    let imageName: String
    
    init(name: SettingNames, imageName: String) {
        self.name = name
        self.imageName = imageName
        
    }
    
    
}
