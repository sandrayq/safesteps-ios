//
//  SettingsRowView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 6/11/24.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName) //xcode symbol images for icons
                .imageScale(.small)
                .font(.title)
                .foregroundStyle(tintColor)
            
            Text(title) //name 
                .font(.subheadline)
                .foregroundStyle(.black)
            
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
