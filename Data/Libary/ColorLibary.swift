//
//  ColorLibary.swift
//  Financy
//
//  Created by Marvin Hülsmann on 21.02.23.
//

import SwiftUI

struct ColorLibary {
    var avaibleColors: [String: Color] = [
        "color.red": SwiftUI.Color.red, "color.yellow": SwiftUI.Color.yellow, "color.green": SwiftUI.Color.green, "color.grey": SwiftUI.Color(UIColor.lightGray), "color.blue": SwiftUI.Color.blue, "Indigo": SwiftUI.Color.indigo, "color.turquoise": SwiftUI.Color.cyan, "color.brown" : SwiftUI.Color.brown, "color.purple": SwiftUI.Color.purple, "Orange": SwiftUI.Color.orange, "Pink": SwiftUI.Color.pink, "color.mint": SwiftUI.Color.mint, "Teal": SwiftUI.Color.teal
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
