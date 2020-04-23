//
//  ContentView.swift
//  Navigation
//
//  Created by Luis Ascorbe on 23/04/2020.
//  Copyright © 2020 Luis Ascorbe. All rights reserved.
//

import SwiftUI

protocol Coordinating {
    associatedtype SwiftUIView: View
}

protocol UIKitCoordinating {
    func present()
}
