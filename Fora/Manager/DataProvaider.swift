//
//  DataProvaider.swift
//  Fora
//
//  Created by Александр Сахнюков on 25/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit

class DataProvider {
    
    var imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage)
        } else {
         networkManager.fetchImage(url: url) { [weak self] (image) in
            guard let self = self else { return }
            self.imageCache.setObject(image, forKey: url as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
    }
}
}
