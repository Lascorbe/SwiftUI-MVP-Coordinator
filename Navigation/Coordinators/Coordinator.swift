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
    func present(viewModel: T, tag: Int, selection: Binding<Int?>) -> SwiftUIView
}

protocol ModalCoordinating: Coordinating {
    associatedtype T: ViewModel
    func present(viewModel: T, isPresented: Binding<Bool>) -> (() -> SwiftUIView)
}

protocol UIKitCoordinating {
    func present()
}
