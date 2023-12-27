//
//  MyZone.swift
//  Detezo
//
//  Created by Pankaj Sonava on 22/12/23.
//

import SwiftUI


struct MyZone: View {
 
    @StateObject var zoneVM = ZoneVM()
    @State var showBottomSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    DashboardHeader(centerTitle: MyZoneScreenTexts.myZone) {
                        showBottomSheet = true
                    }
                }.frame(height: 50)
                Spacer().frame(height: 40)
                DetezoMainOutlineButton(buttonTitle: MyZoneScreenTexts.createNewZone).frame(width: ScreenWidth - 38)                
                List {
                    ForEach(0..<zoneVM.zones.count, id: \.self) { zone in
                        ZStack{
                            ZoneRow(zone: zoneVM.zones[zone])
                        }.listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 20))
                        
                    }.listRowBackground(Color.clear)
                }.scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(PlainListStyle())
                Spacer()
                
            }.background(Color.appBG)
        }.navigationBarBackButtonHidden()
        .onAppear{
            listData()
        }
        .fullScreenCover(isPresented: $showBottomSheet) {
            Spacer()
            ZStack(alignment: .bottom) {
                
                BottomSheet(editAccountAction: {
                    showBottomSheet = false
                }, changePassAction: {
                    showBottomSheet = false
                }, contactSupportAction: {
                    showBottomSheet = false
                }, logOutAction: {
                    showBottomSheet = false
                })
                    .presentationBackground(.modelBg)
                    .transition(.move(edge: .leading))
            }
            
            .background(Color.appBG)

            
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func listData() {
        zoneVM.assignDemoData()
    }
}

#Preview {
    MyZone()
}

