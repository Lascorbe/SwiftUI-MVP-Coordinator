//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

enum MasterFactory {
    typealias ViewType = MasterView<MasterPresenter<DetailCoordinator, DetailRedCoordinator>>
    
    static func make() -> ViewType {
        let presenter = MasterPresenter(detailCoordinator: DetailCoordinator(),
                                        detailRedCoordinator: DetailRedCoordinator(),
                                        detailRedModalCoordinator: DetailRedModalCoordinator())
        let view = MasterView(presenter: presenter)
        return view
    }
}
