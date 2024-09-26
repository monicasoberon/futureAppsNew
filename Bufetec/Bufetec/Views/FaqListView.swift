//
//  FaqListView.swift
//  Bufetec
//
//  Created by Julen Hoppenstedt on 26/09/24.
//

import SwiftUI

//struct FaqListView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

struct FaqListView: View {
    @ObservedObject var viewModel = FaqViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.faqs, id: \.id) { faq in
                VStack(alignment: .leading) {
                    Text(faq.question)
                        .font(.headline)
                    Text(faq.answer)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Preguntas Frecuentes")
            .onAppear {
                viewModel.fetchFAQs()
            }
        }
    }
}

#Preview {
    FaqListView()
}


