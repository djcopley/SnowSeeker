//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Daniel Copley on 2/11/23.
//

import SwiftUI

enum SortOrder: String, CaseIterable, Identifiable {
    public var id: Self { self }
    case ascending, descending
}

enum SortMethod: String, CaseIterable, Identifiable {
    var id: Self { self }
    case `default`, name, country, price, runs
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @StateObject var favorites = Favorites()

    @State private var selectedResort: Resort? = nil
    @State private var searchText = ""
    
    @State private var sortMethod = SortMethod.default
    @State private var sortOrder = SortOrder.ascending
    
    
    var filteredAndSortedResorts: [Resort] {
        var result = resorts
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
        
        switch sortMethod {
        case .name:
            result = result.sorted { $0.name < $1.name }
        case .country:
            result = result.sorted { $0.country < $1.name }
        case .price:
            result = result.sorted { $0.price < $1.price }
        case .runs:
            result = result.sorted { $0.runs < $1.runs }
        default:
            break
        }
        
        switch sortOrder {
        case .ascending:
            break
        case .descending:
            result = result.reversed()
        }
        
        return result
    }
        
    var body: some View {
        NavigationSplitView {
            List(filteredAndSortedResorts, selection: $selectedResort) { resort in
                NavigationLink(value: resort) {
                    resortRow(resort)
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                Menu {
                    Menu("Sort By") {
                        Picker("Sort By", selection: $sortMethod) {
                            ForEach(SortMethod.allCases) { method in
                                Text(method.rawValue.capitalized)
                            }
                        }
                        
                        Picker("Order", selection: $sortOrder) {
                            ForEach(SortOrder.allCases) { order in
                                Text(order.rawValue.capitalized)
                            }
                        }
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
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
