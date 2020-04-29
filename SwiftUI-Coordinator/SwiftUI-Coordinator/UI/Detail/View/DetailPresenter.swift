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

final class DetailPresenter<C: DetailCoordinator>: Presenter<C>, DetailPresenting {
    @Published private(set) var viewModel: DetailViewModel? {
        didSet {
//            let vm = String(describing: viewModel)
//            print("\(self) viewModel: \(vm)")
        }
    }
    
    init(viewModel: DetailViewModel?,
         coordinator: C) {
        self.viewModel = viewModel
        super.init(coordinator: coordinator)
    }
    
    func buttonPressed(isActive: Binding<Bool>) -> some View {
        return coordinator?.presentNextView(isPresented: isActive)
    }
}
