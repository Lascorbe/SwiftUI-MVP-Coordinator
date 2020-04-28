//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailCoordinator: Coordinator {}

extension DetailCoordinator {
    func presentNextView(isPresented: Binding<Bool>) -> some View {
        let coordinator = NavigationMasterCoordinator<Self>(viewModel: nil, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

final class NavigationDetailCoordinator<P: Coordinator>: DetailCoordinator {
    private let viewModel: DetailViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    deinit {
        print("\(identifier) deinit NavigationDetailCoordinator")
        stop()
    }
    
    @discardableResult
    func start() -> some View {
        let view = DetailFactory.make(with: viewModel, coordinator: self)
        // Showing how NavigationReturnWrapper works
        return NavigationReturnWrapper(isPresented: isPresented, destination: view)
    }
}
