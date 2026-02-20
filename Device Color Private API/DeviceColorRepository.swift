import SwiftUI
import DeviceKit

struct DeviceColorRepository {
    static func loadReport() async -> DeviceColorReport {
        let modelCode = hardwareModel()
        let colors = readDeviceColors()
        let colorToken = normalizedColorToken(from: colors.enclosureColor, fallback: colors.deviceColor)
        let matchingType = matchingDeviceType(modelCode: modelCode, colorToken: colorToken)
        let fallbackModelName = matchingType?.description ?? "Unknown Device"
        
        return DeviceColorReport(
            deviceName: fullDeviceName(fallback: fallbackModelName),
            modelName: fallbackModelName,
            modelCode: modelCode,
            deviceColor: colors.deviceColor,
            deviceEnclosureColor: colors.enclosureColor
        )
    }
    
    private static func readDeviceColors() -> (deviceColor: String, enclosureColor: String) {
        let device = UIDevice.current
        let selector = selectorForDeviceInfo(on: device)
        
        guard let selector else {
            return ("unknown", "unknown")
        }
        
        let deviceColor = performDeviceInfoCall(on: device, selector: selector, key: "DeviceColor")
        let enclosureColor = performDeviceInfoCall(on: device, selector: selector, key: "DeviceEnclosureColor")
        return (deviceColor ?? "unknown", enclosureColor ?? "unknown")
    }
    
    private static func selectorForDeviceInfo(on device: UIDevice) -> Selector? {
        let modernSelector = NSSelectorFromString("deviceInfoForKey:")
        if device.responds(to: modernSelector) {
            return modernSelector
        }
        
        let legacySelector = NSSelectorFromString("_deviceInfoForKey:")
        if device.responds(to: legacySelector) {
            return legacySelector
        }
        
        return nil
    }
    
    private static func performDeviceInfoCall(on device: UIDevice, selector: Selector, key: String) -> String? {
        guard let unmanagedResult = device.perform(selector, with: key) else {
            return nil
        }
        return unmanagedResult.takeUnretainedValue() as? String
    }
    
    private static func normalizedColorToken(from enclosureColor: String, fallback deviceColor: String) -> String {
        let trimmedEnclosure = enclosureColor.trimmingCharacters(in: .whitespacesAndNewlines)
        let base = trimmedEnclosure.isEmpty || trimmedEnclosure.lowercased() == "unknown" ? deviceColor : trimmedEnclosure
        return base.replacingOccurrences(of: "#", with: "").lowercased()
    }
    
    private static func matchingDeviceType(modelCode: String, colorToken: String) -> DeviceTypeDeclaration? {
        let types = exportedDeviceTypes()
        let matchingModelTypes = types.filter { $0.modelCodes.contains(modelCode) }
        
        if let exactColorMatch = matchingModelTypes.first(where: { $0.identifier.lowercased().hasSuffix(colorToken) }) {
            return exactColorMatch
        }
        
        return matchingModelTypes.first
    }
    
    private static func exportedDeviceTypes() -> [DeviceTypeDeclaration] {
        guard
            let declarationsURL = Bundle.main.url(forResource: "DeviceTypeDeclarations", withExtension: "plist"),
            let rawTypes = NSArray(contentsOf: declarationsURL) as? [[String: Any]]
        else {
            return []
        }
        
        return rawTypes.compactMap { rawType in
            guard
                let description = rawType["UTTypeDescription"] as? String,
                let identifier = rawType["UTTypeIdentifier"] as? String
            else {
                return nil
            }
            
            let tagSpecification = rawType["UTTypeTagSpecification"] as? [String: Any]
            let modelCodes = tagSpecification?["com.apple.device-model-code"] as? [String] ?? []
            
            return DeviceTypeDeclaration(
                description: description,
                identifier: identifier,
                modelCodes: modelCodes
            )
        }
    }
    
    private static func hardwareModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        return withUnsafePointer(to: &systemInfo.machine) { machinePointer in
            machinePointer.withMemoryRebound(to: CChar.self, capacity: 1) { cStringPointer in
                String(cString: cStringPointer)
            }
        }
    }
    
    private static func fullDeviceName(fallback: String) -> String {
        let name = Device.current.description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !name.isEmpty, name.lowercased() != "unknown" else {
            return fallback
        }
        
        return name
    }
}

private struct DeviceTypeDeclaration {
    let description: String
    let identifier: String
    let modelCodes: [String]
}
