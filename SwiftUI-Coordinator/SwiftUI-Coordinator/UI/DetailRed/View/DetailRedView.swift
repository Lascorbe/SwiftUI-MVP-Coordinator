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
        print(presentationMode.wrappedValue.isPresented)
        
    }

    var body: some View {
        Group { // we need to put the `if` in a Group or the compiler won't know what we're returning
            if presentationMode.wrappedValue.isPresented {
                Content(presenter: presenter)
                    .navigationBarItems(
                        trailing: Button(
                            action: {
                                withAnimation {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            })
                        {
                            Text("Dismiss")
                        }
                    )
            } else {
                Content(presenter: presenter)
            }
        }
    }
}

private struct Content<T: DetailRedPresenting>: View {
    @ObservedObject var presenter: T
    
    @State private var isActive: Bool = false
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.81, green: 0.38, blue: 0.33, alpha: 0.3))
                .edgesIgnoringSafeArea(.all)
            if presenter.viewModel != nil {
                Button(action: {
                    self.isActive.toggle()
                }) {
                    Text("\(presenter.viewModel!.date, formatter: dateFormatter)")
                        .background(
                            presenter.buttonPressed(isActive: $isActive)
                        )
                }
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
        return DetailRedFactory.make(with: DetailRedViewModel(date: Date()), coordinator: DetailRedCoordinator(viewModel: nil, isPresented: $isActive))
    }
}
