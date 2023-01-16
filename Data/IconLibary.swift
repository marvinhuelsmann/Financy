//
//  IconLibary.swift
//  Financy
//
//  Created by Marvin Hülsmann on 16.01.23.
//

import Foundation

struct IconLibary {
    var avaibleIcons = [
        "paperplane", "doc", "bolt", "camera", "car", "airplane.departure", "ferry", "scooter", "fuelpump", "house.lodge", "tent.2", "ipad.gen2", "lamp.desk", "popcorn", "chair", "gamecontroller", "carrot", "dollarsign.square", "facemask", "iphone", "macpro.gen3", "macpro.gen2", "figure.wave", "keyboard", "airtag", "display", "macstudio", "applewatch", "airpodsmax", "airpodspro", "homepodmini", "hifispeaker", "appletvremote.gen4"
    ]
    
    func getAvaibleIcons() -> Array<String> {
        return avaibleIcons
    }
}
