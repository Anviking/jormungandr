//
//  ContentView.swift
//  Test
//
//  Created by Johannes Lund on 2019-11-16.
//  Copyright © 2019 Johannes Lund. All rights reserved.
//

import SwiftUI

let q = DispatchQueue(label: "fetcher")

struct ContentView: View {
    @State private var stake = ""

    var body: some View {
        VStack {
            Button(action: {
                fetchStake { self.stake = $0 ?? "" }
            }) { Text("Get stake") }
            
            Button(action: {
                fetchInfo { self.stake = $0 ?? "" }
            }) { Text("Get info") }
            
            Text(self.stake)
                .font(.custom("Menlo", size: 12))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func fetchStake(completion: @escaping (String?) -> ()) {
    let url = URL(string: "http://127.0.0.1:8080/api/v0/stake")!
    let session = URLSession(configuration: .default)
    let t = session.dataTask(with: url) { data, res, err in
        print(err)
        DispatchQueue.main.async {
            completion(data.flatMap { String(data: $0, encoding: .utf8) })
        }
    }
    t.resume()
}

func fetchInfo(completion: @escaping (String?) -> ()) {
    let url = URL(string: "http://127.0.0.1:8080/api/v0/node/stats")!
    let session = URLSession(configuration: .default)
    let t = session.dataTask(with: url) { data, res, err in
        print(err)
        DispatchQueue.main.async {
            completion(data.flatMap { String(data: $0, encoding: .utf8) })
        }
    }
    t.resume()
}
