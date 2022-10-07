//
//  TaskGroupBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by 조성규 on 2022/10/07.
//

import SwiftUI
private let urlString = "https://picsum.photos/200"

class TaskGroupBootcampDataManager {
    
    func fetchImagesWithAsyncLet() async -> [UIImage] {
        async let fetchedImage1 = fetchImage(urlString: urlString)
        async let fetchedImage2 = fetchImage(urlString: urlString)
        async let fetchedImage3 = fetchImage(urlString: urlString)
        async let fetchedImage4 = fetchImage(urlString: urlString)
        
        let (image1, image2, image3, image4) = await (try? fetchedImage1, try? fetchedImage2, try? fetchedImage3, try? fetchedImage4)
        
        return [image1, image2, image3, image4].compactMap { $0 }
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(100)
            
            for _ in 0..<5 {
                group.addTask {
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
//            group.addTask {
//                try await self.fetchImage(urlString: urlString)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: urlString)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: urlString)
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: urlString)
//            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
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
}

class TaskGroupBootcampViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupBootcampDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
    
}

struct TaskGroupBootcamp: View {
    @StateObject private var viewModel = TaskGroupBootcampViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group 😏")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

struct TaskGroupBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupBootcamp()
    }
}
