import Foundation

struct ServerConfig {
    private static var config: [String: Any] = {
        guard let url = Bundle.main.url(forResource: "Property List", withExtension: "plist") else {
            fatalError("❌ Config.plist not found in the bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("❌ Unable to read data from Config.plist.")
        }
        
        guard let config = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            fatalError("❌ Failed to parse Config.plist.")
        }
        
        return config
    }()
    
    static var serverIP: String {
        guard let serverIP = config["ServerIP"] as? String else {
            fatalError("❌ Missing 'ServerIP' key in Config.plist.")
        }
        return serverIP
    }
    
    static var port: String {
        guard let port = config["Port"] as? String else {
            fatalError("❌ Missing 'Port' key in Config.plist.")
        }
        return port
    }
    
    static var mode: Int {
        guard let mode = config["mode"] as? Int else {
            fatalError("❌ Missing 'mode' key in Config.plist.")
        }
        return mode
    }
    
    static var link: String {
        guard let link = config["link"] as? String else {
            fatalError("❌ Missing 'link' key in Config.plist.")
        }
        return link
    }
    
    func getBaseUrl() -> String {
        if ServerConfig.mode == 1 {
            return "http://\(ServerConfig.serverIP):\(ServerConfig.port)"
        }
        return ServerConfig.link
    }
}
