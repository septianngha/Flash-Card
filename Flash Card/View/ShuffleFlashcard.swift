//
//  ShuffleFlashcard.swift
//  Flash Card
//
//  Created by Muhamad Septian Nugraha on 20/11/24.
//

import SwiftUI

struct ShuffleFlashcard: View {
    @ObservedObject var viewModel: FlashcardViewModel
    
    @State private var selectedImage: String? = nil
    @State private var shakeFirstImage = false
    @State private var shakeSecondImage = false
    
    @State private var navigateToNextPage = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 40) {
                
                Text("Pilih salah satu gambar")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack() {
                    
                    // Gambar Pertama
                    Image("image1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .border(selectedImage == "english" ? Color.blue : Color.clear, width: 3)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedImage = "english"
                        }
                        .modifier(FlashcardViewModel.ShakeEffect(shakes: shakeFirstImage ? 3 : 0))
                        .padding(.horizontal, 20)
                    
                    // Gambar Kedua
                    Image("image2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .border(selectedImage == "indonesian" ? Color.blue : Color.clear, width: 3)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedImage = "indonesian"
                        }
                        .modifier(FlashcardViewModel.ShakeEffect(shakes: shakeFirstImage ? 3 : 0))
                    
                }
                
                
                // Button Start Shuffle
                Button(action: {
                    if selectedImage == nil {
                        shakeFirstImage = true
                        shakeSecondImage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            shakeFirstImage = false
                            shakeSecondImage = false
                        }
                    } else if viewModel.flashcards.isEmpty {
                        showAlert = true
                    } else {
                        navigateToNextPage = true
                    }
                }) {
                    Text("Start Shuffle")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 30)
                
                // Navigasi ke halaman berikutnya
                NavigationLink(
                    destination: StartShuffleFlashcard(viewModel: viewModel, imageValue: selectedImage),
                    isActive: $navigateToNextPage
                ) {
                    EmptyView() 
                }
                
                // Show alert pemberitahuan
                .alert("Pemberitahuan", isPresented: $showAlert) {
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text("Silahkan inputkan word dan translations.")
                }
                
                
            }
            
        }
        .tint(.black)
        
    }
}


struct ShuffleFlashcard_Preview: PreviewProvider {
    static var previews: some View {
        let viewModel = FlashcardViewModel()
        ShuffleFlashcard(viewModel: viewModel)
    }
}
