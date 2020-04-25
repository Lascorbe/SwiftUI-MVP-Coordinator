//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

class AppCoordinator: BaseCoordinator {
    weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    @discardableResult
    func start() -> some ReturnWrapper {
        let coordinator = MasterRootCoordinator(window: window)
        return coordinator.coordinate(to: coordinator)
    }
}
