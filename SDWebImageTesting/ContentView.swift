//
//  ContentView.swift
//  SDWebImageTesting
//
//  Created by Tyson Parks on 2020-11-02.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedTab: Int = 1
  
    var body: some View {
      TabView(selection: $selectedTab,
              content:  {
                ImageTranscodingView().tabItem { Text("Transcoding") }.tag(1)
              })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
          .preferredColorScheme(.dark)
    }
}
