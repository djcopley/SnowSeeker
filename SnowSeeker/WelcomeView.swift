//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Daniel Copley on 2/14/23.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to Snowseeker")
                .font(.largeTitle)
            
            Text("Please choose a resort from the left-hand menu. Swipe from the left to show it.")
                .foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
