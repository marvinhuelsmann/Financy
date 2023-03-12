//
//  Financy.swift
//  Financy
//
//  Created by Marvin Hülsmann on 22.02.23.
//

import Foundation


struct Financy {
    private var version: String = "1.0.1"
    private var betaVersion: Bool = true
    
    func getFinancyVersion() -> String {
        return version
    }
    
    func isBetaVersion() -> Bool {
        return betaVersion
    }
}
