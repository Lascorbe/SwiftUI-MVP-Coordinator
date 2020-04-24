//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol MasterPresenting: ObservableObject {
    associatedtype SwiftUIView1: View
    associatedtype SwiftUIView2: View
    associatedtype SwiftUIView3: View
    var viewModel: MasterViewModel { get }
    func add()
    func remove(at index: Int)
    func dateSelected(date: Date, tag: Int, selection: Binding<Int?>) -> SwiftUIView1
    func anotherSelected(date: Date, tag: Int, selection: Binding<Int?>) -> SwiftUIView2
    func modalSelected(date: Date, isPresented: Binding<Bool>) -> SwiftUIView3
}

class MasterPresenter<D: DetailCoordinating, R: DetailRedCoordinating>: MasterPresenting {
    @Published private(set) var viewModel: MasterViewModel {
        didSet {
            print(viewModel)
        }
    }
    
    private let detailCoordinator: D
    private let detailRedCoordinator: R
    private let detailRedModalCoordinator: DetailRedModalCoordinator
    
    init(viewModel: MasterViewModel = MasterViewModel(dates: []),
         detailCoordinator: D,
         detailRedCoordinator: R,
         detailRedModalCoordinator: DetailRedModalCoordinator) {
        self.viewModel = viewModel
        self.detailCoordinator = detailCoordinator
        self.detailRedCoordinator = detailRedCoordinator
        self.detailRedModalCoordinator = detailRedModalCoordinator
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
    
    func anotherSelected(date: Date, tag: Int, selection: Binding<Int?>) -> some View {
        return detailRedCoordinator.present(viewModel: DetailRedViewModel(date: date), tag: tag, selection: selection)
    }
    
    func modalSelected(date: Date, isPresented: Binding<Bool>) -> some View {
        return detailRedModalCoordinator.present(viewModel: DetailRedViewModel(date: date), isPresented: isPresented)
    }
}
