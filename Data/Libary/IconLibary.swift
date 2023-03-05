//
//  IconLibary.swift
//  Financy
//
//  Created by Marvin Hülsmann on 16.01.23.
//

import Foundation

struct IconLibary {
    
    var avaibleIcons = [
        "paperplane", "doc", "bolt", "camera", "car", "airplane.departure", "ferry", "scooter", "fuelpump", "house.lodge", "tent.2", "ipad.gen2", "lamp.desk", "popcorn", "chair", "gamecontroller", "carrot", "dollarsign.square", "facemask", "iphone", "macpro.gen3", "macpro.gen2", "figure.wave", "keyboard", "airtag", "display", "macstudio", "applewatch", "airpodsmax", "airpodspro", "homepodmini", "hifispeaker", "appletvremote.gen4", "xmark", "house.fill", "door.left.hand.closed", "balloon.2", "doc.zipper", "tray.2", "externaldrive.badge.wifi", "cursorarrow.rays", "hare", "tortoise.fill", "textformat.size", "hand.point.up.fill", "person.text.rectangle", "fan.ceiling", "shower", "sink"
    ]
    
    var avaibleGroupIcons = [
        "paperplane", "doc", "bolt", "camera", "car", "airplane.departure", "ferry", "scooter", "fuelpump", "house.lodge", "tent.2", "ipad.gen2", "lamp.desk", "popcorn", "chair", "gamecontroller", "carrot", "dollarsign.square", "facemask", "iphone", "shower", "sink",  "tray.2",  "dollarsign.square", "xmark"
    ]
    
    func getAvaibleProductIcons() -> Array<String> {
        return avaibleIcons
    }
    
    func getAvaibleGroupedIcons() -> Array<String> {
        return avaibleGroupIcons
    }
    
}
