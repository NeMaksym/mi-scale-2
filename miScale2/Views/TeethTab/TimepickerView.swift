//
//  TimepickerView.swift
//  miScale2
//
//  Created by Maksym Netreba on 07.10.2021.
//

import SwiftUI

struct TimepickerView: View {
    @Binding var brushingDuration: Int
    
    var body: some View {
        Picker("Duration", selection: $brushingDuration) {
            ForEach(1..<16) {
                if $0 == 1 {
                    Text("1 minute")
                } else {
                    Text("\($0) minutes")
                }
            }
        }
    }
}

struct TimepickerView_Previews: PreviewProvider {    
    static var previews: some View {
        TimepickerView(brushingDuration: .constant(2))
    }
}
