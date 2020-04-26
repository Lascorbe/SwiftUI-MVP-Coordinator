//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol BaseCoordinator: AssociatedObject {}

protocol StartCoordinator: BaseCoordinator {
    associatedtype U: ReturnWrapper
    func start() -> U
}

protocol StopCoordinator: BaseCoordinator {
    associatedtype P: StopCoordinator
    func stop()
}

protocol FinalCoordinator: StartCoordinator, StopCoordinator {}

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
    
    fileprivate var childs: [UUID: Any] {
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
    
    fileprivate func store<T: BaseCoordinator>(coordinator: T) {
        childs[coordinator.identifier] = coordinator
        print(childs)
    }
    
    fileprivate func free<T: BaseCoordinator>(coordinator: T) {
        childs[coordinator.identifier] = nil
        print(childs)
    }
}
    
extension FinalCoordinator { // Mixin Extension: Check out AssociatedObject.swift
    func coordinate<T: FinalCoordinator>(to coordinator: T) -> some ReturnWrapper {
        store(coordinator: coordinator)
        coordinator.parent = self as? T.P
        return coordinator.start()
    }
}

extension StopCoordinator { // Mixin Extension: Check out AssociatedObject.swift
    fileprivate var parent: P? {
        get { associatedObject(for: &childsKey) }
        set { setAssociatedObject(newValue, for: &childsKey) }
    }
    
    func stop() {
        parent?.free(coordinator: self)
    }
}

private var identifierKey: UInt8 = 0
private var childsKey: UInt8 = 0
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
