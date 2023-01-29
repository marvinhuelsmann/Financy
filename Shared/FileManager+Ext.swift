//
//  FileManager+Ext.swift
//  Financy
//
//  Created by Marvin Hülsmann on 17.01.23.
//

import Foundation

extension FileManager {
    static let appGroupContainerURL = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.marvhuelsmann.financy")!
}

