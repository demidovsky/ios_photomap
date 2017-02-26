//
//  ImageDownloader.swift
//  CatMap
//
//  Created by Митрошка on 26.02.17.
//  Copyright © 2017 dimmy.pro. All rights reserved.
//

import UIKit

extension UIImageView
{
    func showImage(url:String)
    {
        self.image = nil
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        guard
            let urlObject = URL(string: url)
        else { return }
        
        let task = session.dataTask(with: urlObject, completionHandler:
        {
            (data, _, __) in
            guard
                let imageData = data,
                let image = UIImage(data: imageData)
            else { return }

            // Обязательно переключиться в основной поток
            DispatchQueue.main.async
            {
                self.image = image
            }
        })
        
        task.resume()
    }
}


