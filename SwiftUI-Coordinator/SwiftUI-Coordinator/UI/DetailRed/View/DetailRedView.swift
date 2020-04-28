//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

struct DetailRedView<T: DetailRedPresenting>: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var presenter: T
    
    private var viewModel: DetailRedViewModel? {
        return presenter.viewModel
    }
    
    @State private var isActive: Bool = false
    
    init(presenter: T) {
        self.presenter = presenter
    }

    var body: some View {
        // we need to put the `if` in a Group, or the compiler won't know what we're returning
        Group {
            // is there a way to know if this is presented inside a NavigationView?
            if presenter.shouldShowDimiss {
                Content(presenter: presenter)
                    .navigationBarItems(
                        leading: leftButton,
                        trailing: rightButton
                    )
            } else {
                Content(presenter: presenter)
            }
        }
    }
    
    private var leftButton: some View {
        NavigationButton(contentView: Text("Go to Detail"),
                         navigationView: { isPresented in
                            self.presenter.buttonPressed(isActive: isPresented)
        })
    }
    private var rightButton: some View {
        Button(
            action: {
                withAnimation {
                    self.presentationMode.wrappedValue.dismiss()
                }
        }) {
            Text("Dismiss")
        }
    }
}

private struct Content<T: DetailRedPresenting>: View {
    @ObservedObject var presenter: T
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.81, green: 0.38, blue: 0.33, alpha: 0.3))
                .edgesIgnoringSafeArea(.all)
            if presenter.viewModel != nil {
                NavigationButton(contentView: Text("\(presenter.viewModel!.date, formatter: dateFormatter)"),
                                 navigationView: { isPresented in
                                    self.presenter.buttonPressed(isActive: isPresented)
                })
                .foregroundColor(Color.blue)
            } else {
                Text("This view was not presented as a modal")
            }
        }
        .navigationBarTitle(Text("DetailRed"))
    }
}


struct DetailRedView_Previews: PreviewProvider {
    @State static var isActive = false
    
    static var previews: some View {
        return DetailRedFactory.make(with: DetailRedViewModel(date: Date()), coordinator: NavigationDetailRedCoordinator<AppCoordinator>(viewModel: nil, isPresented: $isActive))
    }
}
