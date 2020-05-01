//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

enum DetailRedFactory {
    static func make<T: DetailRedBaseCoordinator>(with viewModel: DetailRedViewModel?, coordinator: T, shouldShowDimiss: Bool = false) -> some View {
        let presenter = DetailRedPresenter(viewModel: viewModel, coordinator: coordinator, shouldShowDimiss: shouldShowDimiss)
        let view = DetailRedView(presenter: presenter)
        return view
    }
}
