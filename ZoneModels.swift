//
//  ZoneModels.swift
//  Detezo
//
//  Created by Pankaj Sonava on 26/12/23.
//

import Foundation
import SwiftUI

struct Zone {
  let name: String
  let allowedApps: [RestrictApp]
}

struct RestrictApp {
    let appName: String
    let enabled: Bool
    let editable: Bool
    let icon: String
}

let CallApp = RestrictApp(appName: "Call", enabled: true, editable: true, icon: "ic_zone_call")
let CameraApp = RestrictApp(appName: "Camera", enabled: true, editable: true, icon: "ic_zone_camera")
let MessageApp = RestrictApp(appName: "Message", enabled: true, editable: true, icon: "ic_zone_msg")
let FlashApp = RestrictApp(appName: "Flash", enabled: true, editable: true, icon: "ic_zone_flash")
