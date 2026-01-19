//
//  CandidateCardView.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import SwiftUI

struct CandidateCardView: View {
    @State private var isFavorite = true
    @State private var noteText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived"
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header with avatar and name
                    VStack(spacing: 16) {
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text("JMP")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(.white)
                                )
                                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)

                            Button(action: { isFavorite.toggle() }) {
                                Image(systemName: isFavorite ? "star.fill" : "star")
                                    .foregroundColor(isFavorite ? .yellow : .gray)
                                    .font(.system(size: 20))
                            }
                            .offset(x: 8, y: -8)
                        }

                        Text("Jean Michel P.")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 24)

                    // Contact Information Cards
                    VStack(spacing: 12) {
                        ContactInfoRow(
                            icon: "phone.fill",
                            label: "Phone",
                            value: "09 12 12 32 32",
                            color: .green
                        )

                        ContactInfoRow(
                            icon: "envelope.fill",
                            label: "Email",
                            value: "jeanmichelp@toto.com",
                            color: .blue
                        )

                        // LinkedIn Button
                        Button(action: {
                            // Open LinkedIn
                        }) {
                            HStack {
                                Image(systemName: "link.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("LinkedIn")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Go on LinkedIn")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                }

                                Spacer()

                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    // Notes Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Note", systemImage: "note.text")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Spacer()

                            Button(action: { isEditing.toggle() }) {
                                Text(isEditing ? "Done" : "Edit")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }

                        if isEditing {
                            TextEditor(text: $noteText)
                                .frame(minHeight: 150)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        } else {
                            Text(noteText)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .padding(.top, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Text("Edit")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct ContactInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    CandidateCardView()
}
