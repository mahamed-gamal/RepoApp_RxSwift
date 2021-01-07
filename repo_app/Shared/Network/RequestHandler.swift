//
//  RequestHandler.swift
//  repo_app
//
//  Created by Mohamed Gamal on 1/7/21.
//  Copyright © 2021 Me. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration
import SwiftyJSON

enum NetworkError: String {
    case Error422 = "Bad Request"
    case Error401 = "Your session has been expired, please login again!"
    case Error500 = "Server Error"
    case Error501, Error502 = "We're currently updating our server, please try again later."
}

final public class RequestHandler {
    
    //MARK: Returns the singleton RequestHandler instance.
    static var shared:RequestHandler = RequestHandler()
    private let network = SCNetworkReachabilityCreateWithName(nil, "www.google.com") //For Internet Connection Check
    
    //MARK: default request
    var manager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5 // seconds
        configuration.timeoutIntervalForResource = 5
        self.manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    //MARK: Get Request
    func get(url: String, parameters: Parameters? = nil, header: [String: String] = ["Accept": "application/json"], encoding: URLEncoding = URLEncoding.queryString, loader: Bool = true, completion: @escaping (Data?, Bool?, Error?) -> ()) {
        print("Request_*********************")
        print("Request_URL --> \(url)")
        print("Request_-----")
        print("Request_PARAMTERS --> \(parameters)")
        print("Request_-----")
        print("Request_HEADER --> \(header)")
        print("Request_---  Calling API  --")
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: encoding, headers: header).validate(statusCode: 200..<503).responseJSON { (response) in
            self.handleResponse(response: response, completion: { (data, success, error) in
                completion(data, success, error)
            })
        }
    }
    
    func post(url: String, parameters: Parameters? = nil, header: [String: String] = ["Accept": "application/json"], encoding: JSONEncoding = .default, completion: @escaping(Data?, Bool?, Error?) -> ()) {
        print("Request_*********************")
        print("Request_URL --> \(url)")
        print("Request_-----")
        print("Request_PARAMTERS --> \(parameters)")
        print("Request_-----")
        print("Request_HEADER --> \(header)")
        print("Request_---  Calling API  --")
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: encoding, headers: header).validate(statusCode: 200..<503).responseJSON { (response) in
            self.handleResponse(response: response, completion: { (data, success, error) in
                completion(data, success, error)
            })
        }
    }
    
    func patch( showLoader: Bool, url: String, parameters: Parameters? = nil, header: [String: String] = ["Accept": "application/json"], encoding: URLEncoding = URLEncoding.queryString, completion: @escaping (Data?, Bool?, Error?) -> ()) {
        print("Request_*********************_START")
        print("Request_URL --> \(url)")
        print("Request_-----")
        print("Request_PARAMTERS --> \(parameters)")
        print("Request_-----")
        print("Request_HEADER --> \(header)")
        print("Request_---  Calling API  --")
        
        Alamofire.request(url, method: .patch, parameters: parameters, encoding: encoding, headers: header).validate(statusCode: 200..<503).responseJSON { (response) in
            self.handleResponse(response: response, completion: { (data, success, error) in
                completion(data, success, error)
            })
        }
    }
    
    
    func delete( url: String, parameters: Parameters? = nil, header: [String: String] = ["Accept": "application/json"], encoding: URLEncoding = URLEncoding.queryString, completion: @escaping (Data?, Bool?, Error?) -> ()) {
        print("Request_*********************_START")
        print("Request_URL --> \(url)")
        print("Request_-----")
        print("Request_PARAMTERS --> \(parameters)")
        print("Request_-----")
        print("Request_HEADER --> \(header)")
        print("Request_---  Calling API  --")
        
        
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: encoding, headers: header).validate(statusCode: 200..<503).responseJSON { (response) in
            self.handleResponse(response: response, completion: { (data, success, error) in
                completion(data, success, error)
            })
        }
    }
    
    //MARK: Check for internet connection before making request
    private func isNetworkAvailable() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        guard let network = self.network else { return false }
        SCNetworkReachabilityGetFlags(network, &flags)
        print(flags)
        if(isNetworkReachable(with: flags)) {
            debugPrint("REACHABLE VIA WIFI")
            return true
        } else {
            debugPrint("NOT REACHABLE")
            return false
        }
    }
    
    //MARK: Helper function for checking internet connection
    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    
    //MARK: Handle API response and deliver it to API file for parsing
    fileprivate func handleResponse(response: DataResponse<Any>, completion: @escaping (Data?, Bool?, Error?) -> ()) {
        print("Request_CODE --> \(response.result.value)")
        print("Request_RESPONSE --> \(response.description)")
        print("Request_*********************_END")
       
        switch response.response?.statusCode {
        case 422:
            completion(response.data, false, response.error)
        case 401:
            
            completion(nil, false, response.error)
        case 500:
            
            completion(nil, false, response.error)
        case 501:
            
            completion(nil, false, response.error)
        case 502:
            
            completion(nil, false, response.error)
        default:
            switch response.result {
            case .success:
                if let data = response.data {
                    completion(data, true, nil)
                }
            case .failure (let error):
                
                completion(nil, false, error)
            }
        }
    }
}



extension RequestHandler {
    
    func upload(_ link: String, image: UIImage, imageName: String, method: HTTPMethod ,hideLoader:Bool, completion: @escaping(Data?, Bool?, String?) -> ()) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            if image.jpegData(compressionQuality: 1.0) != nil {
                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "path", fileName: "user", mimeType: "image/jpg")
            }
        }, to: link, method: method , headers: ["Content-Type": "application/json","Accept": "application/json"], encodingCompletion: { result in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress { progress in // main queue by default
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
                upload.responseJSON { response in
                    print(response)
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            print(data)
                            completion(data, true, nil)
                        } else { }
                    case .failure( _):
                        // SAM
                        completion(nil, false, "something went wrong during upload images")
                        break
                    }
                }
            case .failure( _):
                break
            }
        })
    }

    func uploadData(video: Data?, pdfFile: Data?, audio: Data?, url: String, fileName: String? = "file", ext: String = "pdf", completion: @escaping(Data?, Bool?, String?) -> ()) {
        Alamofire.upload(multipartFormData: { (form) in
            if let video = video {
                form.append(video, withName: "file", fileName: "\(fileName ?? "video.mp4")", mimeType: "video/\(ext)")
            }
            if let audio = audio {
                form.append(audio, withName: "file", fileName: "recording.m4a", mimeType: "audio/m4a")
            }
            if let pdfFile = pdfFile {
                //                        multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "path", fileName: "user", mimeType: "image/jpg")
                form.append(pdfFile, withName: "path", fileName: "\(fileName ?? "file.pdf")", mimeType: "application/pdf")
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: ["Content-Type": "application/json","Accept": "application/json"]) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.validate(statusCode: 200...422)
                upload.responseJSON { response in
                    switch response.result {
                    case .failure( _):
                        // SAM
                        completion(nil, false, "something went wrong during upload images")
                        break
                    case .success( _):
                        if let data = response.data {
                            print(data)
                            completion(data, true, nil)
                        } else { }
                    }
                }
            case .failure( _):
                break
                // end
            }
        }
    }
    
    
    func requestSwiftyJSON(requestApi: String, method: HTTPMethod , body: Parameters? = nil, headers:[String:String], encoding: ParameterEncoding = JSONEncoding.default, completion: @escaping (JSON, Bool, String)->()) {
        
        //Only Post methods accepts body request, otherwise use URLEncoding to append param
        Alamofire.request(requestApi, method: method, parameters: body, encoding: encoding, headers:headers).validate(statusCode: 200..<400).responseJSON { (response) in
            print(response)
            switch response.response?.statusCode {
                
            case 422:
                completion(JSON.null, false, "Bad Request.")
                
            case 401:
                completion(JSON.null, false, "Unautherized.")
                
            default:
                switch response.result {
                case .success:
                    if response.result.error == nil {
                        guard let data = response.data else {
                            completion(JSON.null, false, response.error?.localizedDescription ?? "Server didn't respond.")
                            return
                        }
                        let json = try! JSON(data: data)
                        completion(json, true, "")
                    } else {
                        completion(JSON.null, false, response.error?.localizedDescription ?? "No Internet Connection!")
                    }
                case .failure:
                    completion(JSON.null, false, response.error?.localizedDescription ?? "No Internet Connection!")
                }
            }
        }
    }
    
}

