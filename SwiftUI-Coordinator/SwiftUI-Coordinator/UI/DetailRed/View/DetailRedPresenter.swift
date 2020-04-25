//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailRedPresenting: ObservableObject {
    associatedtype U: View
    var viewModel: DetailRedViewModel? { get }
    var shouldShowDimiss: Bool { get }
    func buttonPressed(isActive: Binding<Bool>) -> U
}

class DetailRedPresenter<C: DetailRedBaseCoordinator>: DetailRedPresenting {
    @Published private(set) var viewModel: DetailRedViewModel? {
        didSet {
            print(viewModel!)
        }
    }
    
    private(set) var shouldShowDimiss: Bool
    
    private let coordinator: C
    
    init(viewModel: DetailRedViewModel? = DetailRedViewModel(date: Date()),
         coordinator: C,
         shouldShowDimiss: Bool) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.shouldShowDimiss = shouldShowDimiss
    }
    
    func buttonPressed(isActive: Binding<Bool>) -> some View {
        let vm: DetailViewModel? = (viewModel != nil) ? DetailViewModel(date: viewModel!.date) : nil
        return coordinator.presentNextView(viewModel: vm, isPresented: isActive)
    }
}
