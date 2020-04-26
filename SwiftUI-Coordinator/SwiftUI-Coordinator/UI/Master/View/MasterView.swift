//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

struct MasterView<T: MasterPresenting>: View {
    @ObservedObject private var presenter: T
    
    init(presenter: T) {
        self.presenter = presenter
    }

    var body: some View {
        Content(presenter: presenter)
            .navigationBarTitle(Text("Master"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(
                    action: {
                        withAnimation {
                            self.presenter.add()
                        }
                }
                ) {
                    Image(systemName: "plus")
                }
            )
            // .onAppear: excuted everytime you come back from a NavigationLink,
            //            but it doesn't run after coming back from a Modal (.sheet) 🤷🏻‍♂️
    }
}

private struct Content<T: MasterPresenting>: View {
    @ObservedObject var presenter: T
    
    var body: some View {
        List {
            ForEach(presenter.viewModel.dates, id: \.self) { date in
                Row(presenter: self.presenter, date: date)
            }.onDelete { indices in
                indices.forEach { self.presenter.remove(at: $0) }
            }
        }
    }
}

struct ProductFamilyRowStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .colorMultiply(configuration.isPressed ?
                Color.white.opacity(0.5) : Color.white)
    }
}

// This view needs to be a separate struct from Content, otherwise NavigationLink gets mad
private struct Row<T: MasterPresenting>: View {
    @ObservedObject var presenter: T
    
    var date: Date
    
    @State private var isPresented1 = false
    @State private var isPresented2 = false
    @State private var isPresented3 = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(date, formatter: dateFormatter)")
                    .padding(.bottom)
                
                Button(action: {
                    self.isPresented1 = true
                }) {
                    Text("Go Detail")
                        .background(
                            self.presenter.firstSelected(date: date, isPresented: $isPresented1)
                    )
                }
                .foregroundColor(Color.green)
                .padding(.bottom)
                
                Button(action: {
                    self.isPresented2 = true
                }) {
                    Text("Go Detail Red")
                        .background(
                            self.presenter.secondSelected(date: date, isPresented: $isPresented2)
                    )
                }
                .foregroundColor(Color.red)
                .padding(.bottom)
                
                Button(action: {
                    self.isPresented3 = true
                }) {
                    Text("Go Detail Red Modal")
                        .background(
                            self.presenter.modalSelected(date: date, isPresented: $isPresented3)
                    )
                }
                .foregroundColor(Color.red)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .buttonStyle(ProductFamilyRowStyle())
    }
}

struct MasterView_Previews: PreviewProvider {
    private static var dates: [Date] = {
        var dates = [Date]()
        dates.insert(Date(), at: 0)
        dates.insert(Date(), at: 0)
        dates.insert(Date(), at: 0)
        dates.insert(Date(), at: 0)
        dates.insert(Date(), at: 0)
        return dates
    }()
    
    static var previews: some View {
        return MasterFactory.make(with: MasterViewModel(dates: dates), coordinator: RootMasterCoordinator<AppCoordinator>(window: nil))
    }
}
