//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by 조성규 on 2022/10/07.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let 🥳")
            .onAppear {
                Task {
                    do {
                        
                        async let fetchImage1 = fetchImage()
                        async let fetchTitle1 = fetchTitle()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        
                        let (image1, image2, image3, image4) = await (try? fetchImage1, try? fetchImage2, try? fetchImage3, try? fetchImage4)
                        
                        
//                        guard let image1 = try await fetchImage() else { return }
//                        self.images.append(image1)
//
//                        guard let image2 = try await fetchImage() else { return }
//                        self.images.append(image2)
//
//                        guard let image3 = try await fetchImage() else { return }
//                        self.images.append(image3)
//
//                        guard let image4 = try await fetchImage() else { return }
//                        self.images.append(image4)
                        
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage? {
        do {
            guard let url = url else { return UIImage(systemName: "heart.fill") }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
    
    func fetchTitle() async -> String {
        return "NEW TITLE"
    }
}

struct AsyncLetBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetBootcamp()
    }
}
