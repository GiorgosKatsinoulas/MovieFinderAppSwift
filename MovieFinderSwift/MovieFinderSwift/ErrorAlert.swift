//
//  ErrorAlert.swift
//  MovieFinderSwift
//
//  Created by Giorgos Katsinoulas on 23/10/23.
//

import SwiftUI

struct ErrorAlert: View {
    @Binding var isPresented: Bool

    let alertMessage: String

    var body: some View {
        Alert(
            title: Text("Error"),
            message: Text(alertMessage),
            dismissButton: .default(Text("OK")) {
                isPresented = false
            }
        )
    }
}
