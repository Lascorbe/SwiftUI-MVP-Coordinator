//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol MasterBaseCoordinator: BaseCoordinator {
    associatedtype RW1: ReturnWrapper
    associatedtype RW2: ReturnWrapper
    associatedtype RW3: ReturnWrapper
    func presentDetailView(viewModel: DetailViewModel, isPresented: Binding<Bool>) -> RW1
    func presentDetailRedView(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> RW2
    func presentDetailRedViewInModal(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> RW3
}

class MasterCoordinator: MasterBaseCoordinator {
    weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let view = MasterFactory.make(with: self)
        let navigation = NavigationView { view }
        let hosting = UIHostingController(rootView: navigation)
        window?.rootViewController = hosting
        window?.makeKeyAndVisible()
        return EmptyReturnWrapper(destination: EmptyView())
    }
}

extension MasterCoordinator {
    func presentDetailView(viewModel: DetailViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        return EmptyReturnWrapper(destination: EmptyView())
    }
    
    func presentDetailRedView(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        return EmptyReturnWrapper(destination: EmptyView())
    }
    
    func presentDetailRedViewInModal(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> some ReturnWrapper {
        return EmptyReturnWrapper(destination: EmptyView())
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

//typealias SwiftUIView = NavigationLink<EmptyView, MasterFactory.ViewType>
//
//func present(isActive: Binding<Bool>) -> SwiftUIView {
//    let view = MasterFactory.make()
//    return NavigationLink(destination: view, isActive: isActive) { EmptyView() }
//}
