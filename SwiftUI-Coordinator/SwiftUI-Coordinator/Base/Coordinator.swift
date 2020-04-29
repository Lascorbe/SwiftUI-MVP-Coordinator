//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol Coordinator: AssociatedObject {
    associatedtype U: View
    associatedtype P: Coordinator
    func start() -> U
    func stop()
}

extension Coordinator { // Mixin Extension: Check out AssociatedObject.swift
    private(set) var identifier: UUID {
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
    
    private(set) var children: [UUID: Any] {
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
    
    private(set) weak var parent: P? {
        get { associatedObject(for: &childrenKey) }
        set { setAssociatedObject(newValue, for: &childrenKey, policy: .weak) }
    }
    
    private func store<T: Coordinator>(coordinator: T) {
        children[coordinator.identifier] = coordinator
//        print("\(identifier) store children: \(children.count)")
    }
    
    private func free<T: Coordinator>(coordinator: T) {
        children.removeValue(forKey: coordinator.identifier)
//        print("\(identifier) free children: \(children.count)")
    }
    
    func stop() {
        children.removeAll()
        parent?.free(coordinator: self)
    }
    
    func coordinate<T: Coordinator>(to coordinator: T) -> some View {
        store(coordinator: coordinator)
        coordinator.parent = self as? T.P
        return coordinator.start()
    }
}

private var identifierKey: UInt8 = 0
private var childrenKey: UInt8 = 0
private var parentKey: UInt8 = 0
