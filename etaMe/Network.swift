//
//  Network.swift
//  etaMe
//
//  Created by akburak zekeriya on 07/01/2025.
//

import Foundation

struct ServerConfig {
    static var serverIP: String {
           guard let url = Bundle.main.url(forResource: "Property List", withExtension: "plist") else {
               fatalError("❌ Impossible de trouver Config.plist dans le bundle.")
           }

           guard let data = try? Data(contentsOf: url) else {
               fatalError("❌ Impossible de lire les données du fichier Config.plist.")
           }

           guard let config = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
               fatalError("❌ Impossible de parser Config.plist.")
           }

           guard let serverIP = config["ServerIP"] as? String else {
               fatalError("❌ Clé 'ServerIP' manquante dans Config.plist.")
           }

           return serverIP
       }
    
    static var port: String {
        guard let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let port = config["Port"] as? String else {
            fatalError("Impossible de charger le Port du serveur depuis Config.plist")
        }
        return port
    }
    
}





