//
//  LoadingView.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 03/08/24.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = UIColor.gray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(Color.clear)
                .ignoresSafeArea()
            ActivityIndicatorView()
        }
    }
}

#Preview {
    LoadingView()
}
