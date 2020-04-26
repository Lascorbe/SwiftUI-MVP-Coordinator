//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol MasterBaseCoordinator: FinalCoordinator {}

extension MasterBaseCoordinator {
    func presentDetailView(viewModel: DetailViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = DetailCoordinator<Self>(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
    
    func presentDetailRedView(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = DetailRedCoordinator<Self>(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
    
    func presentDetailRedViewInModal(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = DetailRedModalCoordinator<Self>(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

final class MasterRootCoordinator<P: FinalCoordinator>: MasterBaseCoordinator {
    weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let view = MasterFactory.make(with: MasterViewModel(dates: [Date()]), coordinator: self)
        let navigation = NavigationView { view }
//            .navigationViewStyle(StackNavigationViewStyle())
        let hosting = UIHostingController(rootView: navigation)
        window?.rootViewController = hosting
        window?.makeKeyAndVisible()
        return EmptyReturnWrapper(destination: EmptyView())
    }
}

final class MasterCoordinator<P: FinalCoordinator>: MasterBaseCoordinator {
    private let viewModel: MasterViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: MasterViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        // Is there a better way to do this if?
        if let viewModel = viewModel {
            return NavigationReturnWrapper(isPresented: isPresented,
                                           destination: MasterFactory.make(with: viewModel, coordinator: self)
                                            .onDisappear(perform: { [weak self] in
                                                self?.stop()
                                            }))
        } else {
            return NavigationReturnWrapper(isPresented: isPresented,
                                           destination: MasterFactory.make(coordinator: self)
                                            .onDisappear(perform: { [weak self] in
                                                self?.stop()
                                            }))
        }
    }
}
