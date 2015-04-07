//
//  FIONetworkClientConfiguration.swift
//  Fillio
//
//  Created by Kévin MACHADO on 23/03/2015.
//  Copyright (c) 2015 Kévin MACHADO. All rights reserved.
//

import Foundation

protocol FIONetworkClientConfigurationDelegate {
    func didChangedSessionConfig(config: FIONetworkClientConfiguration)
}

public enum FIONetworkHTTPSessionType{
    case EphemeralSession
    case DefaultSession
    case BackgroundSession(identifier: String)
}

public class FIONetworkClientConfiguration {
    
    public init() {}
    
    /// The delegate
    var delegate: FIONetworkClientConfigurationDelegate?
    
    /// A boolean value that determines whether the connection should be executed with cellular network or only wifi (The default value is true)
    public var allowCellularAccess: Bool = true {
        didSet {
            if let d = delegate {
                d.didChangedSessionConfig(self)
            }
        }
    }
    
    /// A boolean value that determines whether the task should start automatically (The default value is false)
    public var autostartTask = false
    
    /// The type of the session (The default value is DefaultSession)
    public var sessionType: FIONetworkHTTPSessionType = FIONetworkHTTPSessionType.DefaultSession {
        didSet {
            if let d = delegate {
                d.didChangedSessionConfig(self)
            }
        }
    }
    
    func defaultHTTPHeaders() -> [String: String] {
        
        // Accept-Encoding HTTP Header; see http://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0,compress;q=0.5"
        
        // Accept-Language HTTP Header; see http://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage: String = {
            var components: [String] = []
            for (index, languageCode) in enumerate(NSLocale.preferredLanguages() as [String]) {
                let q = 1.0 - (Double(index) * 0.1)
                components.append("\(languageCode);q=\(q)")
                if q <= 0.5 {
                    break
                }
            }
            
            return join(",", components)
            }()
        
        // User-Agent Header; see http://tools.ietf.org/html/rfc7231#section-5.5.3
        let userAgent: String = {
            if let info = NSBundle.mainBundle().infoDictionary {
                let executable: AnyObject = info[kCFBundleExecutableKey] ?? "Unknown"
                let bundle: AnyObject = info[kCFBundleIdentifierKey] ?? "Unknown"
                let version: AnyObject = info[kCFBundleVersionKey] ?? "Unknown"
                let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
                
                var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
                let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
                if CFStringTransform(mutableUserAgent, nil, transform, 0) == 1 {
                    return mutableUserAgent as NSString
                }
            }
            return "Fillio"
        }()
        
        return ["Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent]
    }
    
    /// The session configuration
    var sessionConfig: NSURLSessionConfiguration {
        
        var configuration: NSURLSessionConfiguration
        
        switch sessionType {
        case .BackgroundSession(let identifier):
            configuration = NSURLSessionConfiguration.backgroundSessionConfiguration(identifier)
        case .EphemeralSession:
            configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        case .DefaultSession:
            configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        }
        
        configuration.allowsCellularAccess = allowCellularAccess
        configuration.HTTPAdditionalHeaders = self.defaultHTTPHeaders()

        return configuration
    }
}