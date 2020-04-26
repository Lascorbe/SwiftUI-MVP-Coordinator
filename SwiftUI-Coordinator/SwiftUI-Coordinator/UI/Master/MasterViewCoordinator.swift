//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol MasterBaseCoordinator: BaseCoordinator {}

extension MasterBaseCoordinator {
    func presentDetailView(viewModel: DetailViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = DetailCoordinator(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
    
    func presentDetailRedView(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = DetailRedCoordinator(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
    
    func presentDetailRedViewInModal(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        let coordinator = DetailRedModalCoordinator(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

final class MasterRootCoordinator: MasterBaseCoordinator {
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

final class MasterCoordinator: MasterBaseCoordinator {
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
            let view = MasterFactory.make(with: viewModel, coordinator: self)
            return NavigationReturnWrapper(isPresented: isPresented, destination: view)
        } else {
            let view = MasterFactory.make(coordinator: self)
            return NavigationReturnWrapper(isPresented: isPresented, destination: view)
        }
    }
}

// We need this wrapper just for the sake of making all the Coordinators conform to the same protocol (BaseCoordinator),
// since the 1st coordinator must rely on UIKit, we are just going to return an empty ReturnWrapper.
// The rest of the SwiftUI navigation should be done through NavigationReturnWrapper and ModalReturnWrapper
// which you can find on Coordinator.swift

struct EmptyReturnWrapper<T: View>: ReturnWrapper {
    typealias DestinationView = T
    var destination: T
    
    var body: some View {
        EmptyView()
    }
}
