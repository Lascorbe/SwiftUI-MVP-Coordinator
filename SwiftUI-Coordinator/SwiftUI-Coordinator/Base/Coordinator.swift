//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol Coordinating {
    associatedtype SwiftUIView: View
}

protocol NavigationLinkCoordinating: Coordinating {
    associatedtype T: ViewModel
    associatedtype U: View
    func present(viewModel: T, tag: Int, selection: Binding<Int?>) -> U
}

protocol ModalCoordinating: Coordinating {
    associatedtype T: ViewModel
    associatedtype U: ReturnWrapper
    func present(viewModel: T, isPresented: Binding<Bool>) -> U
}

protocol UIKitCoordinating {
//    var childs: [UIKitCoordinating] { get }
    func start()
}

protocol BaseCoordinator: AssociatedObjects {
    associatedtype U: ReturnWrapper
    func start() -> U
}

// Mixin Extension

private var identifierKey: UInt8 = 0
private var childsKey: UInt8 = 0

extension BaseCoordinator {
    private var identifier: UUID {
        get {
            guard let identifier: UUID = associatedObject(for: &identifierKey) else {
                self.identifier = UUID()
                return self.identifier
            }
            return identifier
        }
        set {
            setAssociatedObject(newValue, for: &identifierKey)
        }
    }
    
    private var childs: [UUID: Any] {
        get {
            guard let childs: [UUID: Any] = associatedObject(for: &childsKey) else {
                self.childs = [UUID: Any]()
                return self.childs
            }
            return childs
        }
        set {
            setAssociatedObject(newValue, for: &childsKey)
        }
    }
    
    private func store<T: BaseCoordinator>(coordinator: T) {
        childs[coordinator.identifier] = coordinator
    }
    
    private func free<T: BaseCoordinator>(coordinator: T) {
        childs[coordinator.identifier] = nil
    }
    
    func coordinate<T: BaseCoordinator>(to coordinator: T) -> some ReturnWrapper {
        store(coordinator: coordinator)
        return coordinator.start()
    }
}

// MARK: - Return Wrappers

protocol ReturnWrapper: View {
    associatedtype DestinationView: View
    var destination: DestinationView { set get }
}

// Since `.sheet` is a Modifier and returns an unknown type out of SwiftUI, we can wrap it on another view and use that one instead

struct ModalReturnWrapper<T: View>: ReturnWrapper {
    typealias DestinationView = T
    
    @Binding var isPresented: Bool
    var destination: T
    
    var body: some View {
        EmptyView()
            .sheet(isPresented: $isPresented, content: {
                self.destination
            })
    }
}

struct NavigationReturnWrapper<T: View>: ReturnWrapper {
    typealias DestinationView = T
    
    @Binding var isPresented: Bool
    var destination: T
    
    var body: some View {
        NavigationLink(destination: destination, isActive: $isPresented) {
            EmptyView()
        }
    }
}
