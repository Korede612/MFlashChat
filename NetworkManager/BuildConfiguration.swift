//
//  BuildConfiguration.swift
//  NetworkManager
//
//  Created by Oko-osi Korede on 20/03/2024.
//

import Foundation

enum Environment: String {
    case debugDevelopment   =   "Debug Development"
    case releaseDevelopment =   "Release Development"

    case debugStaging       =   "Debug Staging"
    case releaseStaging     =   "Release Staging"

    case debugProduction    =   "Debug Production"
    case releaseProduction  =   "Release Production"
}

class BuildConfiguration {
    static let shared = BuildConfiguration()
    
    var environment: Environment
    
    var baseURL: String {
         switch environment {
         case .debugDevelopment, .releaseDevelopment:
             return Bundle.main.object(forInfoDictionaryKey: "DevelopmentAPI") as! String
         case .debugStaging, .releaseStaging:
             return Bundle.main.object(forInfoDictionaryKey: "StaggingAPI") as! String
         case .debugProduction, .releaseProduction:
             return Bundle.main.object(forInfoDictionaryKey: "ProductionAPI") as! String
         }
     }
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        
        environment = Environment(rawValue: currentConfiguration)!
    }
}
