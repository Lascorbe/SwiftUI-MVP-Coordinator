//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import Foundation

enum DetailRedFactory {
    typealias ViewType = DetailRedView<DetailRedPresenter<MasterCoordinator>>
    
    static func make(with viewModel: DetailRedViewModel?) -> ViewType {
        let presenter = DetailRedPresenter(viewModel: viewModel, masterCoordinator: MasterCoordinator())
        let view = DetailRedView(presenter: presenter)
        return view
    }
}
