//
//  WeightMeasurementView.swift
//  miScale2
//
//  Created by Maksym Netreba on 06.10.2021.
//

import SwiftUI

struct WeightMeasurementView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        HStack {
            Text("Weight:")
            Spacer()
            Text(weightFormattedValue)
        }
    }
    
    var weightFormattedValue: String {
        let weight = Measurement(
            value: modelData.weight,
            unit: UnitMass.kilograms
        )

        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.numberFormatter.minimumFractionDigits = 2
        
        return formatter.string(from: weight)
    }
}

struct WeightMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        WeightMeasurementView()
    }
}
