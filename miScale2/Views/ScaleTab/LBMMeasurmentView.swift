//
//  LBMMeasurmentView.swift
//  miScale2
//
//  Created by Maksym Netreba on 07.10.2021.
//

import SwiftUI

struct LBMMeasurmentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        HStack {
            Text("Lean Body Mass:")
            Spacer()
            Text(lbmFormatted)
        }
    }
    
    private var lbmFormatted: String {
        let weight = Measurement(
            value: modelData.lbm,
            unit: UnitMass.kilograms
        )

        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.numberFormatter.minimumFractionDigits = 2
        
        return formatter.string(from: weight)
    }
}

struct LBMMeasurmentView_Previews: PreviewProvider {
    static var previews: some View {
        LBMMeasurmentView()
            .environmentObject(ModelData())
    }
}
