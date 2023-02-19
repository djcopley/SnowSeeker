//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Daniel Copley on 2/11/23.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @StateObject var favorites = Favorites()

    @State private var selectedResort: Resort? = nil
    @State private var searchText = ""
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
        
    var body: some View {
        NavigationSplitView {
            List(filteredResorts, selection: $selectedResort) { resort in
                NavigationLink(value: resort) {
                    resortRow(resort)
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
        } detail: {
            if let resort = selectedResort {
                ResortView(resort: resort)
            } else {
                WelcomeView()
            }
        }
        .environmentObject(favorites)
    }
    
    @ViewBuilder
    func resortRow(_ resort: Resort) -> some View {
        HStack {
            Image(resort.country)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 25)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 1)
                )
            
            VStack(alignment: .leading) {
                Text(resort.name)
                    .font(.headline)
                Text("\(resort.runs) runs")
                    .foregroundColor(.secondary)
            }
            
            if favorites.contains(resort) {
                Spacer()
                Image(systemName: "heart.fill")
                    .accessibilityLabel("Favorite resort")
                    .foregroundColor(.red)
            }
        }
    }
}

extension View {
    // Not used
    // This part of the tutorial worked for the old navigation view
    // Not sure how to make it work with new nav split view
    @ViewBuilder
    func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            
        } else {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
