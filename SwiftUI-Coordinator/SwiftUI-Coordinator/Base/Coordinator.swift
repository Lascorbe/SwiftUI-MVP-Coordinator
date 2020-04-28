//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol BaseCoordinator: AssociatedObject {}

protocol StartCoordinator: BaseCoordinator {
    associatedtype U: View
    func start() -> U
}

protocol StopCoordinator: BaseCoordinator {
    associatedtype P: StopCoordinator
    func stop()
}

protocol Coordinator: StartCoordinator, StopCoordinator {}

extension BaseCoordinator { // Mixin Extension: Check out AssociatedObject.swift
    fileprivate var identifier: UUID {
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
    
    fileprivate var children: [UUID: Any] {
        get {
            guard let children: [UUID: Any] = associatedObject(for: &childrenKey) else {
                self.children = [UUID: Any]()
                return self.children
            }
            return children
        }
        set {
            setAssociatedObject(newValue, for: &childrenKey)
        }
    }
    
    fileprivate func store<T: BaseCoordinator>(coordinator: T) {
        children[coordinator.identifier] = coordinator
        print(children)
    }
    
    fileprivate func free<T: BaseCoordinator>(coordinator: T) {
        children[coordinator.identifier] = nil
        print(children)
    }
}

extension StopCoordinator { // Mixin Extension: Check out AssociatedObject.swift
    fileprivate weak var parent: P? {
        get { associatedObject(for: &childrenKey) }
        set { setAssociatedObject(newValue, for: &childrenKey, policy: .weak) }
    }
    
    // We don't need children so do we really need a stop() function working with SwiftUI?
    func stop() {
        parent?.free(coordinator: self)
    }
}

extension Coordinator { // Mixin Extension: Check out AssociatedObject.swift
    func coordinate<T: Coordinator>(to coordinator: T) -> some View {
        store(coordinator: coordinator)
        coordinator.parent = self as? T.P
        return coordinator.start()
    }
}

private var identifierKey: UInt8 = 0
private var childrenKey: UInt8 = 0
private var parentKey: UInt8 = 0

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
    var isDetailLink: Bool = true
    
    var body: some View {
        NavigationLink(destination: destination, isActive: $isPresented) {
            EmptyView()
        }.isDetailLink(isDetailLink)
    }
}
