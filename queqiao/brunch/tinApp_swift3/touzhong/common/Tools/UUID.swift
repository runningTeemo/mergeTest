//
//  UUID.swift
//  tinCRM
//
//  Created by Richard.q.x on 16/8/9.
//  Copyright © 2016年 labi3285_lab. All rights reserved.
//

import Foundation

class UUID {
    
    static var uuid: String {
        let service = Bundle.main.bundleIdentifier
        let account = "uuid"
        let uuid = SSKeychain.password(forService: service, account: account)
        if uuid == nil {
            let uuid = Foundation.UUID().uuidString
            SSKeychain.setPassword(uuid, forService: service, account: account)
            return uuid
        }
        return uuid!
    }
    
}
