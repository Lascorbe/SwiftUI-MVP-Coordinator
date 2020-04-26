//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol AppBaseCoordinator: FinalCoordinator {
    var window: UIWindow? { get }
}
    
extension AppBaseCoordinator {
    func presentRoot() -> some ReturnWrapper {
        let coordinator = MasterRootCoordinator<Self>(window: window)
        return coordinator.coordinate(to: coordinator)
    }
}

class AppCoordinator: AppBaseCoordinator {
    typealias P = AppCoordinator
    
    weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() -> some ReturnWrapper {
        return EmptyReturnWrapper()
    }
}

// We need this wrapper just for the sake of making all the Coordinators conform to the same protocol (BaseCoordinator),
// since the 1st coordinator must rely on UIKit, we are just going to return an empty ReturnWrapper.
// The rest of the SwiftUI navigation should be done through NavigationReturnWrapper and ModalReturnWrapper
// which you can find on Coordinator.swift

struct EmptyReturnWrapper: ReturnWrapper {
    typealias DestinationView = EmptyView
    var destination = EmptyView()
    
    var body: some View {
        destination
    }
}
