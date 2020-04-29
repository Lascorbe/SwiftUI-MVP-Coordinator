//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import Foundation

class Presenter<C: Coordinator> {
    private(set) weak var coordinator: C?
    
    init(coordinator: C) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator?.stop()
//        print("\(coordinator?.identifier.description ?? "nil") deinit \(Self.self)")
    }
}
