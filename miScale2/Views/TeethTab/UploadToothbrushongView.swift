//
//  UploadToothbrushongView.swift
//  miScale2
//
//  Created by Maksym Netreba on 07.10.2021.
//

import SwiftUI

struct UploadToothbrushongView: View {
    @EnvironmentObject var hkManager: HKManager

    @State private var showAlert = false
    @State private var alertTitle = ""
    var brushingDuration: Int
    
    var body: some View {
        HStack {
            Spacer()
            Button("Upload") {
                saveToothbrushing()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    dismissButton: .default(Text("Ok"))
                )
            }
            .disabled(false)
            Spacer()
        }
    }
    
    func saveToothbrushing() {
        // 1. Handle toothbrushing timing
        let end = Date()
        let start = Calendar.current.date(
            byAdding: .minute,
            value: -brushingDuration,
            to: end
        ) ?? Date()
        
        // 2. Create sample
        let toothbrushingSample = hkManager.makeCategorySample(
            type: hkManager.toothbrushingType,
            start: start,
            end: end
        )
        
        // 3. Save to store
        hkManager.save(toothbrushingSample) { (success, error) in
            if let error = error {
                print("Error saving toothbrushing sample: \(error.localizedDescription)")
                alertTitle = "Failed"
            } else {
                alertTitle = "Success"
            }
            showAlert = true
        }
    }
}

struct UploadToothbrushongView_Previews: PreviewProvider {
    static var previews: some View {
        UploadToothbrushongView(brushingDuration: 1)
    }
}
