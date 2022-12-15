//
//  ApiManager.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation
import RxSwift
import Alamofire

class ApiManager {
    
    public static func sharedManager()->ApiManager{
        return DependencyInjector.defaultInjector.getContainer().resolve(ApiManager.self)!
    }
    
    private let session: Session
    struct baseUrl {
        static let Url = URL.init(string: URLConstants.BASEURL)!
    }
    
    private let preferenceManagers : PreferenceManager!

    init(preferenceManager: PreferenceManager) {
        preferenceManagers = preferenceManager
        session = Session()
    }
    
    
    private func logNetworkLogs() {
#if DEBUG
        
#endif
    }
    
    
    func getUrlWithPath(path:String, baseUrl:URL = ApiManager.baseUrl.Url)->URL{
        return baseUrl.appendingPathComponent(path)
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    func requestWith(newBaseURL: Bool = false, body: Parameters?=nil, path: String, queryItems:[URLQueryItem]?=nil, method: HTTPMethod ,showIndicator: Bool = true ,headers: HTTPHeaders?=nil, isRequestData: Bool=false, requestMessage: String = "", isArrayRequest: Bool? = false, arrayRequest: [[String: Any]] = [] , arrayIntType : [Int]? = nil) -> Observable<Any>{
        var urlComponent = URLComponents(url: self.getUrlWithPath(path: path), resolvingAgainstBaseURL: false)!
        
        //#if DEBUG
        ConsoleLog.d("URLLLLLLLLLLL -> \(self.getUrlWithPath(path: path))")
        //#endif
        if let json = try? JSONSerialization.data(withJSONObject: body ?? [String:Any](), options: []) {
            if let content = String(data: json, encoding: .utf8) {
                //#if DEBUG
                ConsoleLog.d("JSON Params --> \(content)")
                //#endif
            }
        }
        
        let postReq = AF.request(urlComponent.url!, method: method, parameters: body, encoding: JSONEncoding.default, headers: headers)
        return get(request: postReq, showIndicator: showIndicator, path: path, body: body, method: method)
        
    }
    
    func get(request: DataRequest, showIndicator: Bool = true, path: String?=nil, body: Parameters?=nil, method: HTTPMethod?=nil)-> Observable<Any>{
        return Observable<Any>.create {
            (observer) -> Disposable in
            request
                .responseJSON(completionHandler: { (response: AFDataResponse<Any>)  in
                    if response.error != nil{
                        let code = response.response?.statusCode ?? 0
                        if code == 401 || code == 400 {
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                if(utf8Text.lowercased().contains("unauthorized")){
                                    observer.onError(NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "unauthorized"]))
                                }else{
                                    observer.onError(NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: utf8Text]))
                                }
                                observer.onCompleted()
                            }else{
                                observer.onError(NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "unauthorized"]))
                                observer.onCompleted()
                            }
                        }else {
                            if let error = response.error{
                                ConsoleLog.d("##########Errorrr#########")
                                ConsoleLog.d("URL --> \(request)")
                                observer.onError(error)
                            }
                        }
                        observer.onCompleted()
                    }else{
                        switch response.result {
                        case .success(let JSON):
                            let code = response.response?.statusCode ?? 0
                            ConsoleLog.d("JSON Response --> \(JSON)")
                            if code == 200 {
                                observer.onNext(JSON)
                            }else if code == 401 || code == 403{
                                observer.onError(NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "unauthorized"]))
                            }else{
                                observer.onError(NSError(domain:"", code:code, userInfo:[ NSLocalizedDescriptionKey: "Something Went Wrong"]))
                            }
                            
                            break
                        case .failure(_):
                            observer.onError(NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "Something Went Wrong"]))
                            break
                        }
                        observer.onCompleted()
                    }
                })
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
    
     
    
}


// Internet Checking
import SystemConfiguration

protocol Utilities {}

extension ApiManager: Utilities {
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }

    var currentReachabilityStatus: ReachabilityStatus {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }

        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
}
