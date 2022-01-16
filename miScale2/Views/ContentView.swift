//
//  miScale2App.swift
//  miScale2
//
//  Created by Maksym Netreba on 03.10.2021.
//

import SwiftUI
import HealthKit
import CoreBluetooth

struct ContentView: View {
    @StateObject var modelData = ModelData()
    @StateObject var bleManager = BLEManager()
    
    var body: some View {
        TabView {
            ScaleTabView()
                .tabItem {
                    Label("Scale", systemImage: "1.square.fill")
                }
            
            TeethTabView()
                .tabItem {
                    Label("Teeth", systemImage: "2.square.fill")
                }
            
            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .onAppear() {
            bleManager.measurementsPublisher.assign(to: &modelData.$scaleMeasurments)
        }
        .environmentObject(bleManager)
        .environmentObject(modelData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BLEManager())
            .environmentObject(ModelData())
            .environmentObject(HKManager())
    }
}
