//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol BaseCoordinator: AssociatedObject {
    func stop()
}

extension BaseCoordinator {
    fileprivate(set) var identifier: UUID {
        get {
            guard let identifier: UUID = associatedObject(for: &identifierKey) else {
                self.identifier = UUID()
                return self.identifier
            }
            return identifier
        }
        set { setAssociatedObject(newValue, for: &identifierKey) }
    }
    
    fileprivate(set) var children: [UUID: BaseCoordinator] {
        get {
            guard let children: [UUID: BaseCoordinator] = associatedObject(for: &childrenKey) else {
                self.children = [UUID: BaseCoordinator]()
                return self.children
            }
            return children
        }
        set { setAssociatedObject(newValue, for: &childrenKey) }
    }
    
    fileprivate func store<T: Coordinator>(child coordinator: T) {
        children[coordinator.identifier] = coordinator
    }
    
    fileprivate func free<T: Coordinator>(child coordinator: T) {
        children.removeValue(forKey: coordinator.identifier)
    }
}

protocol Coordinator: BaseCoordinator {
    associatedtype U: View
    associatedtype P: Coordinator
    func start() -> U
    func shouldStop()
}

extension Coordinator {
    private(set) weak var parent: P? {
        get { associatedObject(for: &childrenKey) }
        set { setAssociatedObject(newValue, for: &childrenKey, policy: .weak) }
    }
    
    func coordinate<T: Coordinator>(to coordinator: T) -> some View {
        store(child: coordinator)
        coordinator.parent = self as? T.P
        return coordinator.start()
    }
    
    func stop() {
        children.removeAll()
        parent?.free(child: self)
    }
    
    func shouldStop() {
        stop()
    }
}

private var identifierKey: UInt8 = 0
private var childrenKey: UInt8 = 0
private var parentKey: UInt8 = 0
