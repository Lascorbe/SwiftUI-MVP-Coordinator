//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

enum MasterFactory {
    static func make<T: MasterCoordinator>(with viewModel: MasterViewModel = MasterViewModel(dates: []), coordinator: T) -> some View {
        let presenter = MasterPresenter(viewModel: viewModel, coordinator: coordinator)
        let view = MasterView(presenter: presenter)
        return view
    }
}
