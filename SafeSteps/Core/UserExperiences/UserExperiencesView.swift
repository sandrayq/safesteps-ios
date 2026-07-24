//
//  UserExperiencesView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 25/12/24.
//

import SwiftUI

struct UserExperiencesView: View {
    @State private var experiences: [UserExperience] = []
    @State private var isAddingExperience = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Sub-Heading")
                        .font(.subheadline)
                        .foregroundColor(.gray)) {
                        ForEach(experiences) { experience in
                            VStack(alignment: .leading) {
                                Text(experience.title)
                                    .font(.headline)
                                Text(experience.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(experience.description)
                                    .font(.body)
                            }
                        }
                        .onDelete(perform: deleteExperience)
                    }
                    .navigationTitle("User-Experiences")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { isAddingExperience = true }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
            }
            .sheet(isPresented: $isAddingExperience) {
                AddExperienceView(experiences: $experiences)
            }
        }
    }
    private func deleteExperience(at offsets: IndexSet) {
        experiences.remove(atOffsets: offsets)
    }
}
