//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol DetailRedPresenting: ObservableObject {
    associatedtype SwiftUIView: View
    var viewModel: DetailRedViewModel? { get }
    func buttonPressed(isActive: Binding<Bool>) -> SwiftUIView
}

class DetailRedPresenter<T: MasterCoordinating>: DetailRedPresenting {
    @Published private(set) var viewModel: DetailRedViewModel? {
        didSet {
            print(viewModel!)
        }
    }
    
    private let masterCoordinator: T
    
    init(viewModel: DetailRedViewModel? = DetailRedViewModel(date: Date()),
         masterCoordinator: T) {
        self.viewModel = viewModel
        self.masterCoordinator = masterCoordinator
    }
    
    func buttonPressed(isActive: Binding<Bool>) -> some View {
        return masterCoordinator.present(isActive: isActive)
    }
}
