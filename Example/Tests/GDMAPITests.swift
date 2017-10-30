import UIKit
import XCTest
import GoogleDistanceMatrixSDK
import OHHTTPStubs
import CoreLocation

final class GDMAPITests: XCTestCase {
    private func data(responseFileName: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: responseFileName, withExtension: "json")
        return url.flatMap { try? Data(contentsOf: $0) } ?? Data()
    }
    
    private func stubRequest(responseFileName: String, statusCode: Int32 = 200) {
        OHHTTPStubs.stubRequests(passingTest: { _ in true }) { _ in
            let data = self.data(responseFileName: responseFileName)
            return OHHTTPStubsResponse(data: data, statusCode: statusCode, headers: nil)
        }
    }
    
    private func stubError() {
        self.stubRequest(responseFileName: "error")
    }
    
    func testFetchingTimeDistanceWithoutTraffic() {
        let expectation = self.expectation(description: "time distance response")
        self.stubRequest(responseFileName: "singleOriginDestination")
        
        GDMAPI.getTimeDistance(from: .Address(address: "test"),
                               to: .Address(address: "test2"),
                               parameters: ImperialPessimisticTrafficDrivingPreset) {
                                (result) in
                                let response = result.value
                                XCTAssertEqual(response?.time, 11680.0)
                                XCTAssertEqual(response?.timeInString, "3 hours 15 mins")
                                XCTAssertEqual(response?.destinationAddress, "Victoria, BC, Canada")
                                XCTAssertEqual(response?.originAddress, "Vancouver, BC, Canada")
                                XCTAssertEqual(response?.distance, 114161.0)
                                XCTAssertEqual(response?.distanceInString, "114 km")
                                XCTAssertEqual(response?.timeInTraffic, 11680.0)
                                XCTAssertEqual(response?.timeInTrafficString, "3 hours 15 mins")
                                expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1) { _ in }
    }
    
    func testFetchingTimeDistanceWithTraffic() {
        let expectation = self.expectation(description: "time distance response")
        self.stubRequest(responseFileName: "singleOriginDestinationTraffic")
        
        GDMAPI.getTimeDistance(from: .Coordinates(location: CLLocationCoordinate2D(latitude: 1, longitude: 2)),
                               to: .Place(placeId: "somePlaceId"),
                               parameters: ImperialPessimisticTrafficDrivingPreset) {
                                (result) in
                                let response = result.value
                                XCTAssertNil(result.error)
                                XCTAssertEqual(response?.time, 11680.0)
                                XCTAssertEqual(response?.timeInString, "3 hours 15 mins")
                                XCTAssertEqual(response?.destinationAddress, "Victoria, BC, Canada")
                                XCTAssertEqual(response?.originAddress, "Vancouver, BC, Canada")
                                XCTAssertEqual(response?.distance, 114161.0)
                                XCTAssertEqual(response?.distanceInString, "114 km")
                                XCTAssertEqual(response?.timeInTraffic, 12598.0)
                                XCTAssertEqual(response?.timeInTrafficString, "3 hours 30 mins")
                                expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1) { _ in }
    }
    
    func testFetchingTimeDistanceFailure() {
        let expectation = self.expectation(description: "error response")
        self.stubError()
        GDMAPI.getTimeDistance(from: .Address(address: "test"),
                               to: .Address(address: "test2"),
                               parameters: ImperialPessimisticTrafficDrivingPreset) {
                                (result) in
                                let response = result.value
                                let error = result.error
                                XCTAssertNil(response)
                                XCTAssertEqual(error?.message, "REQUEST_DENIED")
                                expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { _ in }
    }

    func testFetchingTimeDistanceFailureForWrongResponse() {
        let expectation = self.expectation(description: "error response")
        self.stubRequest(responseFileName: "wrongTrafficResponse")
        GDMAPI.getTimeDistance(from: .Address(address: "test"),
                               to: .Address(address: "test2"),
                               parameters: ImperialPessimisticTrafficDrivingPreset) {
                                (result) in
                                let response = result.value
                                let error = result.error
                                XCTAssertNil(response)
                                XCTAssertEqual(error?.message, "UnknownError")
                                expectation.fulfill()
        }
        self.waitForExpectations(timeout: 1) { _ in }
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }

}
