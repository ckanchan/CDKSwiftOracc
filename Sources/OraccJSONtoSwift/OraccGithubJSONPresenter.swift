//
//  OraccGithubJSONPresenter.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 24/12/2017.
//

import Foundation
import ZIPFoundation

let githubURL = URL(string: "https://github.com/oracc/json")!

public struct OraccGithubJSONDownloader {
    let fileManager = FileManager.default
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let request = URLRequest(url: githubURL)

    
    func getListing(){
        let task: URLSessionDataTask = self.session.dataTask(with: request) {(data, response, error) -> Void in
            if let data = data {
                let response = String(data: data, encoding: String.Encoding.utf8)
                print(response ?? "")
            }
        }
        
        task.resume()
    }
}
