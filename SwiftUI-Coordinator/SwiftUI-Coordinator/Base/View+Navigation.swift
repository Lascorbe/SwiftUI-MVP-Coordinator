//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

struct NavigationButton<CV: View, NV: View>: View {
    @State private var isPresented = false
    
    var contentView: CV
    var navigationView: (Binding<Bool>) -> NV
    
    var body: some View {
        Button(action: {
            self.isPresented = true
        }) {
            contentView
                .background(
                    navigationView($isPresented)
                )
        }
    }
}

extension View {
    func withNavigation<T: View>(to destination: T) -> some View {
        background(destination)
    }
}
