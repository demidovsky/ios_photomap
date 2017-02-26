//
//  APIService.swift
//  CatMap
//
//  Created by Митрошка on 26.02.17.
//  Copyright © 2017 dimmy.pro. All rights reserved.
//

import Foundation


class APIService
{
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    
    enum APIError:Error
    {
        case wrongResponse, wrongStatus, wrongJson, wrongBuild
    }
    
    
    
    
    func find(tag:String, success:@escaping (([PhotoInfo]) -> Void), failure:@escaping ((Error) -> Void))
    {
        let url = buildURL(tag: tag)
        let task = session.dataTask(with: url)
        {
            (data, response, error) in
            //print("response: \(response), \n error: \(error), \n data: \(data)")
            
            guard
                error == nil
            else
            {
                failure(error!)
                return
            }
            
            guard
                let serverResponse = response as? HTTPURLResponse,
                let jsonData = data
            else
            {
                failure(APIError.wrongResponse)
                return
            }
            
            guard
                serverResponse.statusCode == 200
            else
            {
                failure(APIError.wrongStatus)
                return
            }
            
            guard
                let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
                let dictionary = jsonObject as? [String:Any]
            else
            {
                failure(APIError.wrongJson)
                return
            }
            
            //print("\n------ RESPONSE ------\n", dictionary)
            
            let photos = self.buildPhotos(from: dictionary)
            guard
                photos.count > 0
            else
            {
                failure(APIError.wrongBuild)
                return
            }
            
            success(photos)
            
        }
        
        task.resume()
        
    }
    
    
    
    
    private func buildPhotos(from json:[String:Any]) -> [PhotoInfo]
    {
        guard
            let photosContainer = json["photos"] as? [String:Any],
            let jsonList = photosContainer["photo"] as? [[String:Any]]
        else
        {
            return []
        }
        
        var photos = [PhotoInfo]()
        
        for photoJson in jsonList
        {
            if let photo = PhotoInfo(json: photoJson)
            {
                photos.append(photo)
            }
        }
        
        return photos
    }
    
    
    
    
    
    func buildURL(tag:String) -> URL
    {
        let params:[String:Any] =
        [
        "method":           "flickr.photos.search",
        "api_key":          "ad431efbeb1a7e0b9e5ececeb7f6e714", // secret: 2c1a9c88d6cdaeee
        "tags":             tag,
        "has_geo":          true,
        "format":           "json",
        "nojsoncallback":   1,
//        "api_sig":          "e6fe3a8a0389050aa087308f91c4e45b",
        "extras":           "geo,url_s,url_l"
        ]
        
        var url = "https://api.flickr.com/services/rest/?"
        
        for (key,value) in params
        {
            url.append("\(key)=\(value)&")
        }
        
        
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        print(url)
        
        return URL(string: url)!  //fileURLWithPath: url)
    }
}
