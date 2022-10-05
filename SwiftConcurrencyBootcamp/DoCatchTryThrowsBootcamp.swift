//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by 조성규 on 2022/10/05.
//

import SwiftUI

// do-catch
// try
// throws

enum NetworkError: Error {
    case badURL
}

class DoCatchTryThrowsBootcampDataManager {
    
    static let shared = DoCatchTryThrowsBootcampDataManager()
    private init() { }
    
    let isActive: Bool = false
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        } else {
            return (nil, NetworkError.badURL)
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT")
        } else {
            return .failure(URLError(.backgroundSessionInUseByAnotherProcess))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "NEW TEXT"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsBootcampDataManager.shared
    
    func fetchTitle() {
        
        /*
         let result = manager.getTitle()
         if let newTitle = result.title {
         self.text = newTitle
         } else if let error = result.error {
         self.text = error.localizedDescription
         }
         */
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        /*
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
         */
        
        let newTitle = try? manager.getTitle3()
        if let newTitle = newTitle {
            self.text = newTitle
        }
    }
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue.opacity(0.3))
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
