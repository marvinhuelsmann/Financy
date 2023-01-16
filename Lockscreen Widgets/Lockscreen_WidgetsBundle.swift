//
//  Lockscreen_WidgetsBundle.swift
//  Lockscreen Widgets
//
//  Created by Marvin Hülsmann on 16.01.23.
//

import WidgetKit
import SwiftUI

@main
struct Lockscreen_WidgetsBundle: WidgetBundle {
    var body: some Widget {
        Lockscreen_Widgets()
        Lockscreen_WidgetsLiveActivity()
    }
}
