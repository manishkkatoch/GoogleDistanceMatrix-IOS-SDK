import Foundation

enum GDMParameterUnit: String {
    case imperial, metric
}

enum GDMParameterTravelMode: String {
    case driving, walking, bicycling, transit
}

enum GDMParameterAvoid: String {
    case tolls, ferries, highways, indoor
}

enum GDMParameterTrafficModel: String {
    case bestGuess = "best_guess"
    case pessimistic, optimistic
}

enum GDMParameterTransitMode: String {
    case bus, subway, train, tram, rail
}

typealias GDMParameterDepartureTime = String
let GDMParameterDepartureTimeNow = "now"

public struct GDMPParameters {
    let unit: GDMParameterUnit
    let travelMode: GDMParameterTravelMode
    let transitMode: GDMParameterTransitMode
    let trafficModel: GDMParameterTrafficModel
    let departureTime: GDMParameterDepartureTime
    
    var dictionary: [String: String] {
        return [
            "unit": unit.rawValue,
            "travel_mode": travelMode.rawValue,
            "transit_mode": transitMode.rawValue,
            "traffic_model": trafficModel.rawValue,
            "departure_time": departureTime
        ]
    }
}

public let ImperialPessimisticTrafficDrivingPreset: GDMPParameters = GDMPParameters(
    unit: .imperial,
    travelMode: .driving,
    transitMode: .bus,
    trafficModel: .pessimistic,
    departureTime: GDMParameterDepartureTimeNow)

public let ImperialOptimisticTrafficDrivingPreset: GDMPParameters = GDMPParameters(
    unit: .imperial,
    travelMode: .driving,
    transitMode: .bus,
    trafficModel: .optimistic,
    departureTime: GDMParameterDepartureTimeNow)

public let ImperialBestGuessTrafficDrivingPreset: GDMPParameters = GDMPParameters(
    unit: .metric,
    travelMode: .driving,
    transitMode: .bus,
    trafficModel: .bestGuess,
    departureTime: GDMParameterDepartureTimeNow)

public let MetricPessimisticTrafficDrivingPreset: GDMPParameters = GDMPParameters(
    unit: .metric,
    travelMode: .driving,
    transitMode: .bus,
    trafficModel: .pessimistic,
    departureTime: GDMParameterDepartureTimeNow)

public let MetricOptimisticTrafficDrivingPreset: GDMPParameters = GDMPParameters(
    unit: .imperial,
    travelMode: .driving,
    transitMode: .bus,
    trafficModel: .optimistic,
    departureTime: GDMParameterDepartureTimeNow)

public let MetricBestGuessTrafficDrivingPreset: GDMPParameters = GDMPParameters(
    unit: .metric,
    travelMode: .driving,
    transitMode: .bus,
    trafficModel: .bestGuess,
    departureTime: GDMParameterDepartureTimeNow)
