//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol BaseCoordinator {
    associatedtype U: ReturnWrapper
    var start: U { get }
}

class Coordinator {
    private var identifier: UUID = UUID()
    private var childs: [UUID: Coordinator] = [:]
    private(set) var parent: Coordinator?
    
    private func store(coordinator: Coordinator) {
        childs[coordinator.identifier] = coordinator
    }
    
    private func free(coordinator: Coordinator) {
        childs[coordinator.identifier] = nil
    }
    
    func coordinate(to coordinator: Coordinator) -> some ReturnWrapper {
        store(coordinator: coordinator)
        coordinator.parent = self
        return coordinator.start
    }
    
    var start: some ReturnWrapper {
        fatalError("Must override in subclass")
        return EmptyReturnWrapper() // We need this return coz otherwise `some` throws an error
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
