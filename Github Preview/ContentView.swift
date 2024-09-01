//
//  ContentView.swift
//  Github Preview
//
//  Created by Amr El-Fiqi on 01/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GithubUser?
    var body: some View {
        VStack(spacing:20) {
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundStyle(.secondary)
                    
            }
            .frame(width: 120, height: 120)

            
            
            Text(user?.name ?? "User Name")
                .bold()
                .font(.title3)
            
            Text(user?.login ?? "User ID")
                .font(.subheadline)
            
            Text(user?.bio ?? "User Bio")
            Spacer()
            
        }
        .padding()
        .task {
            do {
                user = try await getUser()
            } catch GHErrors.invalidURL {
                print("invalid URL")
            } catch GHErrors.invalidData {
                print("invalid data")
            } catch GHErrors.invalidResponse {
                print("invalid response")
            } catch {
                print("unexpected error")
            }
        }
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
    let name: String
}

enum GHErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
