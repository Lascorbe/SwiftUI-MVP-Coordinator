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

//protocol DetailRedModalCoordinating: ModalCoordinating {
//    func present(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> SwiftUIView
//}
//
//struct DetailRedModalCoordinator: DetailRedModalCoordinating {
//    typealias SwiftUIView = (@ViewBuilder () -> View)
//    
//    func present(viewModel: DetailRedViewModel, isPresented: Binding<Bool>) -> (@ViewBuilder () -> View) {
//        let view = DetailRedFactory.make(with: viewModel)
//        return Group {
//            EmptyView()
//                .sheet(isPresented: isPresented, content: { view })
//                .onAppear()
//        }
//    }
//}
