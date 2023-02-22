//
//  ColorLibary.swift
//  Financy
//
//  Created by Marvin Hülsmann on 21.02.23.
//

import SwiftUI

struct ColorLibary {
    var avaibleColors: [String: Color] = [
        "Rot": SwiftUI.Color.red, "Gelb": SwiftUI.Color.yellow, "Grün": SwiftUI.Color.green, "Grau": SwiftUI.Color(UIColor.lightGray), "Blau": SwiftUI.Color.blue, "Indigo": SwiftUI.Color.indigo, "Türkis": SwiftUI.Color.cyan, "Braun" : SwiftUI.Color.brown, "Lila": SwiftUI.Color.purple, "Orange": SwiftUI.Color.orange, "Pink": SwiftUI.Color.pink, "Minze": SwiftUI.Color.mint, "Teal": SwiftUI.Color.teal
    ]
    
    func getAvaibleColors() -> [String: Color] {
        return avaibleColors
    }
    
    func getColor(name: String) -> Color {
        for avaibleColor in avaibleColors {
            if avaibleColor.key == name {
                return avaibleColor.value
            }
        }
        return SwiftUI.Color.gray
    }
    
}
