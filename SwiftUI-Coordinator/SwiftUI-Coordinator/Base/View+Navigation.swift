//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

extension View {
    func withNavigation<T: View>(to destination: T) -> some View {
        background(destination)
    }
}

struct NavigationButton<CV: View, NV: View>: View {
    @State private var isPresented = false
    
    var contentView: CV
    var navigationView: (Binding<Bool>) -> NV
    
    var body: some View {
        Button(action: {
            self.isPresented = true
        }) {
            contentView
                .withNavigation(to:
                    navigationView($isPresented)
                )
        }
    }
}

struct ModalLinkWrapper<T: View>: View {
    typealias DestinationView = T
    
    var destination: T
    @Binding var isPresented: Bool
    
    var body: some View {
        EmptyView()
            .sheet(isPresented: $isPresented, content: {
                self.destination
            })
    }
}

struct NavigationLinkWrapper<T: View>: View {
    typealias DestinationView = T
    
    var destination: T
    @Binding var isPresented: Bool
    var isDetailLink: Bool = true
    
    var body: some View {
        NavigationLink(destination: destination, isActive: $isPresented) {
            EmptyView()
        }.isDetailLink(isDetailLink)
    }
}
