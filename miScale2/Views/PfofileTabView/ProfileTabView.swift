//
//  ProfileView.swift
//  miScale2
//
//  Created by Maksym Netreba on 07.10.2021.
//

import SwiftUI

struct ProfileTabView: View {
    @EnvironmentObject var modelData: ModelData
    
    private let footerTextSettings = "Apple Watch adds approximately 50g. to your weight"
    private let footerTextBio = "These are used to calculate your body metrics, such as \"Body Mass Index\" or \"Body Fat Percentage\""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Settings"), footer: Text(footerTextSettings)) {
                    Toggle(isOn: $modelData.userProfile.subtractWatch) {
                        Text("Subtract Apple Watch weight")
                    }
                }
                
                Section(header: Text("Biometrics"), footer: Text(footerTextBio)) {
                    VStack(alignment: .leading) {
                        Picker("Sex", selection: $modelData.userProfile.sex) {
                            ForEach(UserProfile.SexType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Height")
                        Picker("Height", selection: $modelData.userProfile.height) {
                            ForEach(0..<210) {
                                Text("\($0) cm").tag(Double($0))
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)
                        .clipped()
                        .padding(.bottom)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Age")
                        Picker("Age", selection: $modelData.userProfile.age) {
                            ForEach(0..<100) {
                                Text("\($0) \($0 == 1 ? "yr" : "yrs").").tag(Double($0))
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)
                        .clipped()
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle(Text("Profile"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
            .environmentObject(ModelData())
    }
}
