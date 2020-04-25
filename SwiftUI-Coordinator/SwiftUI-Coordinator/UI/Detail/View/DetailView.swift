//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

struct DetailView<T: DetailPresenting>: View {
    @ObservedObject var presenter: T
    
    private var viewModel: DetailViewModel? {
        return presenter.viewModel
    }
    
    @State private var isActive: Bool = false

    var body: some View {
        Group {
            if viewModel != nil {
                Button(action: {
                    self.isActive.toggle()
                }) {
                    Text("\(viewModel!.date, formatter: dateFormatter)")
                        .background(
                            self.presenter.buttonPressed(isActive: $isActive)
                    )
                }
                .foregroundColor(Color.blue)
            } else {
                Text("Please select a date")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}


struct DetailView_Previews: PreviewProvider {
    @State static var isActive = false
    
    static var previews: some View {
        return DetailFactory.make(with: DetailViewModel(date: Date()), coordinator: DetailCoordinator(viewModel: nil, isPresented: $isActive))
    }
}
