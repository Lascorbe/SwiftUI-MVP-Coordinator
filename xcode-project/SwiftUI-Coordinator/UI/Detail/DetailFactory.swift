//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

enum DetailFactory {
    static func make<T: DetailCoordinator>(with viewModel: DetailViewModel?, coordinator: T) -> some View {
        let presenter = DetailPresenter(viewModel: viewModel, coordinator: coordinator)
        let view = DetailView(presenter: presenter)
        return view
    }
}
