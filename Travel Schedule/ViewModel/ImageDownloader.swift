//
//  ImageDownloader.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.07.2024.
//

import SwiftUI
import SVGKit
import Kingfisher

actor ImageDownloader: Sendable {
    // MARK: - Private properties
    private var cache: [String: Image]

    // MARK: - Inits
    init(cache: [String: Image] = [:]) {
        self.cache = cache
    }

    // MARK: - Methods
    func fetchSvgImage(from urlString: String) async -> Image? {
        if let cached = cache[urlString] {
            return cached
        }

        do {
            guard let url = URL(string: urlString) else {
                return nil
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = SVGKImage(data: data) else {
                return nil
            }
            cache[urlString] = cache[urlString, default: Image(uiImage: image.uiImage).resizable()]
            return cache[urlString]
        } catch {
            return nil
        }
    }

    func fetchImage(from urlString: String) async -> Image? {
        if let cached = cache[urlString] {
            return cached
        }

        do {
            guard let url = URL(string: urlString) else {
                return nil
            }
            let image = try await withCheckedThrowingContinuation { continuation in
                KingfisherManager.shared.retrieveImage(with: url, options: nil) { result in
                    switch result {
                        case .success(let image):
                            continuation.resume(returning: image.image)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                    }
                }
            }
            cache[urlString] = cache[urlString, default: Image(uiImage: image).resizable()]
            return cache[urlString]
        } catch {
            return nil
        }
    }
}
