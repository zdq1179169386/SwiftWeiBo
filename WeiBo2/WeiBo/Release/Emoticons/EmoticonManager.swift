//
//  EmoticonManager.swift
//  WeiBo
//
//  Created by yb on 16/9/29.
//  Copyright © 2016年 朱德强. All rights reserved.
//

import UIKit

class EmoticonManager: NSObject {
    var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    
    override init() {
        super.init()
        
        packages.append(EmoticonPackage.init(id: ""))
        packages.append(EmoticonPackage.init(id: "com.sina.default"))
        packages.append(EmoticonPackage.init(id: "com.apple.emoji"))
        packages.append(EmoticonPackage.init(id: "com.sina.lxh"))

    }

}
