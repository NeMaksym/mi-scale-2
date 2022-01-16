//
//  UploadView.swift
//  miScale2
//
//  Created by Maksym Netreba on 06.10.2021.
//

import SwiftUI
import HealthKit

struct UploadButtonView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var hkManager: HKManager
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    
    var text: String
    var uploadType: UploadType

    var body: some View {
        Button(text) {
            saveMeasurments()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .disabled(false)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
    
    func saveMeasurments() {
        let weightSample = hkManager.makeQuantitySample(
            type: hkManager.bodyMassType,
            unit: .gram(),
            value: modelData.weight * 1000
        )
        
        let BMISample = hkManager.makeQuantitySample(
            type: hkManager.bmiType,
            unit: .count(),
            value: modelData.bmi
        )
        
        let BFPSample = hkManager.makeQuantitySample(
            type: hkManager.bfpType,
            unit: .percent(),
            value: modelData.bfp / 100
        )

        let LBMSample = hkManager.makeQuantitySample(
            type: hkManager.lbmType,
            unit: .gram(),
            value: modelData.lbm * 1000
        )
        
        var samples = [HKQuantitySample]()
        switch uploadType {
        case .weight:
            samples.append(weightSample)
        case .calculated:
            samples.append(contentsOf: [BMISample, BFPSample, LBMSample])
        case .both:
            samples.append(contentsOf: [weightSample, BMISample, BFPSample, LBMSample])
        }
        
        hkManager.save(samples) { (result, error) in
            if let error = error {
                print("Error saving samples: \(error.localizedDescription)")
                alertTitle = "Failed"
            } else {
                print("Save results: \(result)")
                alertTitle = "Success"
            }
            showAlert = true
        }
    }
}

struct UploadButtonView_Previews: PreviewProvider {
    static var previews: some View {
        UploadButtonView(
            text: "Upload",
            uploadType: UploadType.weight
        )
    }
}
