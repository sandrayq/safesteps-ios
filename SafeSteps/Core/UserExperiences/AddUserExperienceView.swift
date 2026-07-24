//
//  AddUserExperienceView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 25/12/24.
//

import SwiftUI

struct AddExperienceView: View {
    @Binding var experiences: [UserExperience]
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var date = Date()
    @State private var description = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Title-Field", text: $title)
                DatePicker("Date-Field", selection: $date, displayedComponents: .date)
                TextEditor(text: $description)
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
                    .padding(.top, 10)
            }
            .navigationTitle("Add-Experience")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel-Button") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save-Button") {
                        addExperience()
                    }
                }
            }
        }
    }

    private func addExperience() {
        let newExperience = UserExperience(title: title, date: date, description: description)
        experiences.append(newExperience)
        dismiss()
    }
}
