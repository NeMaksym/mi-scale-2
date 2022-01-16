//
//  ContentView.swift
//  miScale2 Watch WatchKit Extension
//
//  Created by Maksym Netreba on 11.10.2021.
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
            ProfileTabView()
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
