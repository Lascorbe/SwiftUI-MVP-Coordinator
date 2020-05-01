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

    var body: some View {
        Group {
            if viewModel != nil {
                NavigationButton(contentView: Text("\(viewModel!.date, formatter: dateFormatter)"),
                                 navigationView: { isPresented in
                                    self.presenter.buttonPressed(isActive: isPresented)
                })
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
        return DetailFactory.make(with: DetailViewModel(date: Date()), coordinator: NavigationDetailCoordinator<AppCoordinator>(viewModel: nil, isPresented: $isActive))
    }
}
