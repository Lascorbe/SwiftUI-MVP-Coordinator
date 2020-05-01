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

final class DetailRedPresenter<C: DetailRedBaseCoordinator>: Presenter<C>, DetailRedPresenting {
    @Published private(set) var viewModel: DetailRedViewModel? {
        didSet {
//            let vm = String(describing: viewModel)
//            print("\(self) viewModel: \(vm)")
        }
    }
    
    private(set) var shouldShowDimiss: Bool
    
    init(viewModel: DetailRedViewModel?,
         coordinator: C,
         shouldShowDimiss: Bool) {
        self.viewModel = viewModel
        self.shouldShowDimiss = shouldShowDimiss
        super.init(coordinator: coordinator)
    }
    
    func buttonPressed(isActive: Binding<Bool>) -> some View {
        let vm: DetailViewModel? = (viewModel != nil) ? DetailViewModel(date: viewModel!.date) : nil
        return coordinator?.presentNextView(viewModel: vm, isPresented: isActive)
    }
}
