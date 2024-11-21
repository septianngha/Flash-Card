//
//  AddFlashcardView.swift
//  Flash Card
//
//  Created by Muhamad Septian Nugraha on 19/11/24.
//

import SwiftUI

struct AddFlashcardView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: FlashcardViewModel
    
    @State private var word: String = ""
    @State private var translation: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Word (English)", text: $word)
                TextField("Translation (Indonesian)", text: $translation)
                
                Button("Save") {
                    guard !word.isEmpty, !translation.isEmpty else { return }
                    viewModel.addFlashcard(word: word, translation: translation)
                    presentationMode.wrappedValue.dismiss()
                }
                .tint(.blue)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationBarTitle("Add Flashcard")
        }
    }
}

struct AddFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FlashcardViewModel()
        AddFlashcardView(viewModel: viewModel)
    }
}
