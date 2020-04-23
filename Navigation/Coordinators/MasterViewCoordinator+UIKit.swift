//
//  ContentView.swift
//  Navigation
//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

struct MasterRootCoordinator: UIKitCoordinating {
    weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func present() {
        let view = MasterFactory.make()
        let navigation = NavigationView { view }
        let hosting = UIHostingController(rootView: navigation)
        window?.rootViewController = hosting
    }
}
