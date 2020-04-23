//
//  ContentView.swift
//  Navigation
//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import Foundation

enum DetailFactory {
    typealias ViewType = DetailView<DetailPresenter<MasterCoordinator>>
    
    static func make(with viewModel: DetailViewModel?) -> ViewType {
        let presenter = DetailPresenter(viewModel: viewModel, masterCoordinator: MasterCoordinator())
        let view = DetailView(presenter: presenter)
        return view
    }
}
