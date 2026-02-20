import Foundation

struct DeviceColorReport: Sendable {
    let deviceName: String
    let modelName: String
    let modelCode: String
    let deviceColor: String
    let deviceEnclosureColor: String
    
    var preferredColorToken: String {
        let enclosure = deviceEnclosureColor.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !enclosure.isEmpty, enclosure.lowercased() != "unknown" else {
            return deviceColor
        }
        
        return enclosure
    }
    
    var shareText: String {
  """
  DeviceColor Report
  
  \(deviceName)
  Model: \(modelCode)
  Type: \(modelName)
  DeviceColor: \(deviceColor)
  DeviceEnclosureColor: \(deviceEnclosureColor)
  
  https://github.com/TopScrech/Device-Color-Private-API
  """
    }
}
