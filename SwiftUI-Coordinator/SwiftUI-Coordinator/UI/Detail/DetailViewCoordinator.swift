//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailCoordinating: NavigationLinkCoordinating {
    func present(viewModel: DetailViewModel, tag: Int, selection: Binding<Int?>) -> SwiftUIView
}

struct DetailCoordinator: DetailCoordinating {
    typealias SwiftUIView = NavigationLink<EmptyView, DetailFactory.ViewType>
    
    func present(viewModel: DetailViewModel, tag: Int, selection: Binding<Int?>) -> SwiftUIView {
        let view = DetailFactory.make(with: viewModel)
        return NavigationLink(destination: view, tag: tag, selection: selection) { EmptyView() }
    }
}
