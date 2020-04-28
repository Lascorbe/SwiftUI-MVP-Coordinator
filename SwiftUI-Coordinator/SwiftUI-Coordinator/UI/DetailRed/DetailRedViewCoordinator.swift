//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailRedBaseCoordinator: Coordinator {}

extension DetailRedBaseCoordinator {
    func presentNextView(viewModel: DetailViewModel?, isPresented: Binding<Bool>) -> some View {
        let coordinator = NavigationDetailCoordinator<Self>(viewModel: viewModel, isPresented: isPresented)
        return coordinate(to: coordinator)
    }
}

final class NavigationDetailRedCoordinator<P: Coordinator>: DetailRedBaseCoordinator {
    private let viewModel: DetailRedViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailRedViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    deinit {
        print("\(identifier) deinit NavigationDetailRedCoordinator")
    }
    
    @discardableResult
    func start() -> some View {
        let view = DetailRedFactory.make(with: viewModel, coordinator: self)
        return NavigationLink(destination: view, isActive: isPresented) {
            EmptyView()
        }
    }
}

final class ModalDetailRedCoordinator<P: Coordinator>: DetailRedBaseCoordinator {
    private let viewModel: DetailRedViewModel?
    private var isPresented: Binding<Bool>
    
    init(viewModel: DetailRedViewModel?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.isPresented = isPresented
    }
    
    @discardableResult
    func start() -> some View {
        let view = DetailRedFactory.make(with: viewModel, coordinator: self, shouldShowDimiss: true)
        let destination = NavigationView { view }
        // we need this so on iPad it looks good, using all the space,
        // but turns out that doing this makes the MasterView back button dissapear
        // if we present it in the modal stack (run and press "Go Detail Red Modal" > "Date" > "Date" > MasterView)
//            .navigationViewStyle(StackNavigationViewStyle())
        
        // Showing how ModalReturnWrapper works
        return ModalReturnWrapper(isPresented: isPresented, destination: destination)
    }
}
