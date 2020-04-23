//
//  ContentView.swift
//  Navigation
//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol MasterCoordinating: Coordinating {
    func present(isActive: Binding<Bool>) -> SwiftUIView
}

struct MasterCoordinator: MasterCoordinating {
    typealias SwiftUIView = NavigationLink<EmptyView, MasterFactory.ViewType>
    
    func present(isActive: Binding<Bool>) -> SwiftUIView {
        let view = MasterFactory.make()
        return NavigationLink(destination: view, isActive: isActive) { EmptyView() }
    }
}
