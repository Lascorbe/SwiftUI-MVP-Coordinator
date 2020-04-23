//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailPresenting: ObservableObject {
    associatedtype SwiftUIView: View
    var viewModel: DetailViewModel? { get }
    func buttonPressed(isActive: Binding<Bool>) -> SwiftUIView
}

class DetailPresenter<T: MasterCoordinating>: DetailPresenting {
    @Published private(set) var viewModel: DetailViewModel? {
        didSet {
            print(viewModel!)
        }
    }
    
    private let masterCoordinator: T
    
    init(viewModel: DetailViewModel? = DetailViewModel(date: Date()),
         masterCoordinator: T) {
        self.viewModel = viewModel
        self.masterCoordinator = masterCoordinator
    }
    
    func buttonPressed(isActive: Binding<Bool>) -> some View {
        return masterCoordinator.present(isActive: isActive)
    }
}
