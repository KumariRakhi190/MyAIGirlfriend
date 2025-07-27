//
//  ImageDownloader.swift
//  AIGirlFriend
//
//  Created by Rakhi on 28/07/23.
//

import Foundation

class ImageDownloader {
    
    // Method to download and save the image in the document directory
    func downloadImage(from url: URL, completion: @escaping (_ imageUrl: URL?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0))
                return
            }
            
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageFileURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
            
            do {
                try data.write(to: imageFileURL)
                completion(imageFileURL, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
