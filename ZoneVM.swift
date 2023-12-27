//
//  ZoneVM.swift
//  Detezo
//
//  Created by Pankaj Sonava on 26/12/23.
//

import Foundation

@MainActor class ZoneVM: ObservableObject {
    
    @Published var zones = [Zone]()
    
    func assignDemoData() {
        let zoneOne = Zone(name: "Concert Audience", allowedApps: [CallApp,FlashApp])
        let zoneTwo = Zone(name: "BackStage VIP", allowedApps: [CallApp,CameraApp,MessageApp])
        let zoneThree = Zone(name: "Press & Media", allowedApps: [CallApp,CameraApp,MessageApp,FlashApp])
        let zoneFour = Zone(name: "Event Staff", allowedApps: [CallApp,MessageApp])
        zones += [zoneOne, zoneTwo, zoneThree, zoneFour];
    }
}
