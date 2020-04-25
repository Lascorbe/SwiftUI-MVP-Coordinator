//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailRedBaseCoordinator: BaseCoordinator {}

extension DetailRedBaseCoordinator {
    func presentNextView(viewModel: DetailViewModel?, isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = DetailCoordinator(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

class DetailRedCoordinator: DetailRedBaseCoordinator {
    private let viewModel: DetailRedViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailRedViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let view = DetailRedFactory.make(with: viewModel, coordinator: self)
        return NavigationReturnWrapper(isPresented: isPresented, destination: view)
    }
}

class DetailRedModalCoordinator: DetailRedBaseCoordinator {
    private let viewModel: DetailRedViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailRedViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let view = DetailRedFactory.make(with: viewModel, coordinator: self)
        return ModalReturnWrapper(isPresented: isPresented, destination: NavigationView { view })
    }
}
