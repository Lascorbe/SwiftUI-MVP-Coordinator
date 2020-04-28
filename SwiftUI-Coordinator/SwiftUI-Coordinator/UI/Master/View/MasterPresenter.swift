//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol MasterPresenting: ObservableObject {
    associatedtype U1: View
    associatedtype U2: View
    associatedtype U3: View
    var viewModel: MasterViewModel { get }
    func add()
    func remove(at index: Int)
    func firstSelected(date: Date, isPresented: Binding<Bool>) -> U1
    func secondSelected(date: Date, isPresented: Binding<Bool>) -> U2
    func modalSelected(date: Date, isPresented: Binding<Bool>) -> U3
}

final class MasterPresenter<C: MasterCoordinator>: MasterPresenting {
    @Published private(set) var viewModel: MasterViewModel {
        didSet {
//            let vm = String(describing: viewModel)
//            print("\(self) viewModel: \(vm)")
        }
    }
    
    private weak var coordinator: C?
    
    init(viewModel: MasterViewModel,
         coordinator: C) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        bindViewModel()
    }
    
    deinit {
        coordinator?.stop()
        print("\(coordinator?.identifier.description ?? "nil") deinit MasterPresenter")
    }
    
    func bindViewModel() {
        // You may want to bind your viewModel to a service/DB here
        //
        // Probably thourght a UseCase or Interactor. I wouldn't do
        // a direct request here.
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
    
    func firstSelected(date: Date, isPresented: Binding<Bool>) -> some View {
        return coordinator?.presentDetailView(viewModel: DetailViewModel(date: date), isPresented: isPresented)
    }
    
    func secondSelected(date: Date, isPresented: Binding<Bool>) -> some View {
        return coordinator?.presentDetailRedView(viewModel: DetailRedViewModel(date: date), isPresented: isPresented)
    }
    
    func modalSelected(date: Date, isPresented: Binding<Bool>) -> some View {
        return coordinator?.presentDetailRedViewInModal(viewModel: DetailRedViewModel(date: date), isPresented: isPresented)
    }
}
