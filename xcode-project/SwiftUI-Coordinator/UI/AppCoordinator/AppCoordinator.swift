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
        print("⚠️ deinit AppCoordinator \(identifier)")
    }
    
    @discardableResult
    func start() -> some View {
        let coordinator = RootMasterCoordinator<AppCoordinator>(window: window)
        return coordinate(to: coordinator)
    }
}
