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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(date, formatter: dateFormatter)")
                    .padding(.bottom)
                
                NavigationButton(contentView: Text("Go Detail"),
                                 navigationView: { isPresented in
                                    self.presenter.firstSelected(date: self.date, isPresented: isPresented)
                })
                .foregroundColor(Color.green)
                .padding(.bottom)
                
                NavigationButton(contentView: Text("Go Detail Red"),
                                 navigationView: { isPresented in
                                    self.presenter.secondSelected(date: self.date, isPresented: isPresented)
                })
                .foregroundColor(Color.red)
                .padding(.bottom)
                
                NavigationButton(contentView: Text("Go Detail Red Modal"),
                                 navigationView: { isPresented in
                                    self.presenter.modalSelected(date: self.date, isPresented: isPresented)
                })
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
