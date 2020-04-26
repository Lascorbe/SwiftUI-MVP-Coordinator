//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

final class AppCoordinator: Coordinator {
    weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let coordinator = MasterRootCoordinator(window: window)
        _ = coordinate(to: coordinator)
    }
}
