//
//  Financy.swift
//  Financy
//
//  Created by Marvin Hülsmann on 22.02.23.
//

import Foundation


struct Financy {
    private let version = Bundle.main.appVersionLong
    private let buildNumber = Bundle.main.appBuild
    
    func getFinancyVersion() -> String {
        return version
    }
    
    func getBuildNumber() -> String {
        return buildNumber
    }
}
