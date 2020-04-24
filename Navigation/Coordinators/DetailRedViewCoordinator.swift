//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailRedCoordinating: NavigationLinkCoordinating {
    func present(viewModel: DetailRedViewModel, tag: Int, selection: Binding<Int?>) -> SwiftUIView
}

struct DetailRedCoordinator: DetailRedCoordinating {
    typealias SwiftUIView = NavigationLink<EmptyView, DetailRedFactory.ViewType>
    
    func present(viewModel: DetailRedViewModel, tag: Int, selection: Binding<Int?>) -> SwiftUIView {
        let view = DetailRedFactory.make(with: viewModel)
        return NavigationLink(destination: view, tag: tag, selection: selection) { EmptyView() }
    }
}

// ⚠️ How can we wrap `.sheet`, which returns this 👇, to return it not only from a struct, but from a protocol, so we are able to mock the coordinator if we want to, like with the other ones
// typealias SheetReturnType = SwiftUI.ModifiedContent<SwiftUI.EmptyView, SwiftUI.IdentifiedPreferenceTransformModifier<SwiftUI.SheetPreference.Key>>

//protocol DetailRedModalCoordinating: ModalCoordinating {
//    func present(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> SwiftUIView
//}

struct DetailRedModalCoordinator {
    func present(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> some View {
        let view = DetailRedFactory.make(with: viewModel)
        return EmptyView()
            .sheet(isPresented: isPresented, content: {
                NavigationView { view }
            })
    }
}
