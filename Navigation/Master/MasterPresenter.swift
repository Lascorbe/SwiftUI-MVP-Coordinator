//
//  ContentView.swift
//  Navigation
//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol MasterPresenting: ObservableObject {
    associatedtype SwiftUIView: View
    var viewModel: MasterViewModel { get }
    func add()
    func remove(at index: Int)
    func dateSelected(date: Date, tag: Int, selection: Binding<Int?>) -> SwiftUIView
}

class MasterPresenter<T: DetailCoordinating>: MasterPresenting {
    @Published private(set) var viewModel: MasterViewModel {
        didSet {
            print(viewModel)
        }
    }
    
    private let detailCoordinator: T
    
    init(viewModel: MasterViewModel = MasterViewModel(dates: []),
         detailCoordinator: T) {
        self.viewModel = viewModel
        self.detailCoordinator = detailCoordinator
    }
    
    func add() {
        var dates = viewModel.dates
        dates.insert(Date(), at: 0)
        viewModel = MasterViewModel(dates: dates)
    }
    
    func remove(at index: Int) {
        var dates = viewModel.dates
        dates.remove(at: index)
        viewModel = MasterViewModel(dates: dates)
    }
    
    func dateSelected(date: Date, tag: Int, selection: Binding<Int?>) -> some View {
        return detailCoordinator.present(viewModel: DetailViewModel(date: date), tag: tag, selection: selection)
    }
}
