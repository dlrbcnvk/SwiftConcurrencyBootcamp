//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by 조성규 on 2022/10/07.
//

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                runTest()
            }
    }
}

struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp()
    }
}

struct MyStruct {
    var title: String
}

extension StructClassActorBootcamp {
    
    private func runTest() {
        print("Test started")
        structText1()
    }
    
    private func structText1() {
        let objectA = MyStruct(title: "Starting title!")
        print("Object A: \(objectA)")
        
        var objectB = objectA
        objectB.title = "Second title!"
        print("Object B: \(objectB)")
    }
}
