//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailPresenting: ObservableObject {
    associatedtype U: View
    var viewModel: DetailViewModel? { get }
    func buttonPressed(isActive: Binding<Bool>) -> U
}

final class DetailPresenter<C: DetailCoordinator>: DetailPresenting {
    @Published private(set) var viewModel: DetailViewModel? {
        didSet {
            print(viewModel ?? "\(self) viewModel is nil")
        }
    }
    
    private let coordinator: C
    
    init(viewModel: DetailViewModel? = DetailViewModel(date: Date()),
         coordinator: C) {
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    func buttonPressed(isActive: Binding<Bool>) -> some View {
        return coordinator.presentNextView(isPresented: isActive)
    }
}
