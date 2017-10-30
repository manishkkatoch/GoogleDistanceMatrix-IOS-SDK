import Foundation

typealias GDMDictionary = [String: Any]

public struct GDMResult {
    public let timeInString: String
    public let time: Double
    public let timeInTrafficString: String
    public let timeInTraffic: Double
    public let distance: Double
    public let distanceInString: String
    public let originAddress: String
    public let destinationAddress: String
    
    init?(withDictionary dict: GDMDictionary?) {
        guard let dict = dict else { return nil }
        guard
            let dest_address = (dict["destination_addresses"] as? [String])?[0],
            let org_address = (dict["origin_addresses"] as? [String])?[0],
            let rowZero = (dict["rows"] as? [GDMDictionary])?[0],
            let elementZero = (rowZero["elements"] as? [GDMDictionary])?[0],
            let time = (elementZero["duration"] as? GDMDictionary),
            let timeValue = time["value"] as? Double,
            let timeString = time["text"] as? String,
            let distance = (elementZero["distance"] as? GDMDictionary),
            let distanceValue = distance["value"] as? Double,
            let distanceString = distance["text"] as? String
            else {
                return nil
        }
        
        self.originAddress = org_address
        self.destinationAddress = dest_address
        self.time = timeValue
        self.timeInString = timeString
        
        if let timeInTraffic = (elementZero["duration_in_traffic"] as? GDMDictionary) {
            guard let timeInTrafficValue = timeInTraffic["value"] as? Double,
                let timeInTrafficString = timeInTraffic["text"] as? String
                else {
                    return nil
            }
            self.timeInTraffic = timeInTrafficValue
            self.timeInTrafficString = timeInTrafficString
        }
        else {
            self.timeInTraffic = self.time
            self.timeInTrafficString = self.timeInString
        }
        
        
        self.distance = distanceValue
        self.distanceInString = distanceString
    }
}
