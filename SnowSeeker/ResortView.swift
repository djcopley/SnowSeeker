//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Daniel Copley on 2/14/23.
//

import SwiftUI

struct ResortView: View {
    var resort: Resort
    @EnvironmentObject var favorites: Favorites
    
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    var isFavorite: Bool {
        favorites.contains(resort)
    }
    
    var favoriteButtonString: String {
        isFavorite ? "Remove from favorites" : "Add to favorites"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                    .overlay(alignment: .bottomTrailing) {
                        Button(action: updateResortFavorite) {
                            Label("Favorite", systemImage: isFavorite ? "heart.fill" : "heart")
                                .font(Font.headline.bold())
                                .bold()
                                .labelStyle(.iconOnly)
                                .foregroundColor(isFavorite ? .red : colorScheme == .light ? .black : .white)
                                .padding(6)
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(5)
                    }
                
                HStack {
                    if sizeClass == .compact && typeSize > .large {
                        VStack (spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack (spacing: 10) { SkiDetailView(resort: resort) }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                showingFacility = true
                                selectedFacility = facility
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    Text("Image Credit: \(resort.imageCredit)")
                        .font(.caption)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
            // Just use default action
        } message: { resort in
            Text(resort.description)
        }
    }
    
    func updateResortFavorite() {
        if isFavorite {
            favorites.remove(resort: resort)
        } else {
            favorites.add(resort: resort)
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResortView(resort: Resort.allResorts.randomElement()!)
        }
        .environmentObject(Favorites())
    }
}
