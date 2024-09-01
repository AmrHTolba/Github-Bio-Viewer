//
//  ContentView.swift
//  Github Preview
//
//  Created by Amr El-Fiqi on 01/09/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing:20) {
            Circle()
                .foregroundStyle(.secondary)
                .frame(width: 120, height: 120)
            
            Text("Username")
                .bold()
                .font(.title3)
            Text("This is where the Github bio will go. Let's make it long so it spans two lines")
            Spacer()
            
        }
        .padding()
    }
    
    func getUser() async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/amrhtolba"
        guard let url = URL(string: endpoint) else {throw GHErrors.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHErrors.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GithubUser.self, from: data)
        } catch {
            throw GHErrors.invalidData
        }
    }
}

#Preview {
    ContentView()
}


struct GithubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}

enum GHErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
