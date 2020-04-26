//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailBaseCoordinator: FinalCoordinator {}

extension DetailBaseCoordinator {
    func presentNextView(isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = MasterCoordinator<Self>(viewModel: nil, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

class DetailCoordinator<P: FinalCoordinator>: DetailBaseCoordinator {
    private let viewModel: DetailViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let view = DetailFactory.make(with: viewModel, coordinator: self)
            .onDisappear(perform: { [weak self] in
                self?.stop()
            })
        return NavigationReturnWrapper(isPresented: isPresented, destination: view)
    }
}
