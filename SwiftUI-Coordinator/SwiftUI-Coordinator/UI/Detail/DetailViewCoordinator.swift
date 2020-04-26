//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

class DetailBaseCoordinator: Coordinator {
    func presentNextView(isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = MasterCoordinator(viewModel: nil, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

final class DetailCoordinator: DetailBaseCoordinator {
    private let viewModel: DetailViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let view = DetailFactory.make(with: viewModel, coordinator: self)
        return NavigationReturnWrapper(isPresented: isPresented, destination: view)
    }
}
