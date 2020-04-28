//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

final class AppCoordinator: Coordinator {
    typealias P = AppCoordinator
    
    weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    deinit {
        print("deinit AppCoordinator \(identifier)")
    }
    
    @discardableResult
    func start() -> some View {
        let coordinator = RootMasterCoordinator<AppCoordinator>(window: window)
        return coordinate(to: coordinator)
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
