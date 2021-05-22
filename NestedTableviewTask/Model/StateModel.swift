

import Foundation

// MARK: - State
struct State: Codable {
    let stateList: [StateList]?
}

// MARK: State convenience initializers and mutators

extension State {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(State.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        stateList: [StateList]?? = nil
    ) -> State {
        return State(
            stateList: stateList ?? self.stateList
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - StateList
struct StateList: Codable {
    var isExpanded:Bool?
    var stateName: String?
    var districtList: [DistrictList]?
}

// MARK: StateList convenience initializers and mutators

extension StateList {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StateList.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        isExpanded: Bool?? = nil,
        stateName: String?? = nil,
        districtList: [DistrictList]?? = nil
    ) -> StateList {
        return StateList(
            isExpanded: isExpanded ?? self.isExpanded,
            stateName: stateName ?? self.stateName,
            districtList: districtList ?? self.districtList
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - DistrictList
struct DistrictList: Codable {
    var  isExpanded:Bool?
    var districtName: String?
    var areaList: [AreaList]?
}

// MARK: DistrictList convenience initializers and mutators

extension DistrictList {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DistrictList.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        isExpanded: Bool?? = nil,
        districtName: String?? = nil,
        areaList: [AreaList]?? = nil
    ) -> DistrictList {
        return DistrictList(
            isExpanded: isExpanded ?? self.isExpanded,
            districtName: districtName ?? self.districtName,
            areaList: areaList ?? self.areaList
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AreaList
struct AreaList: Codable {
    var  isExpanded: Bool?
    var areaName: String?
    var shopList: [String]?
}

// MARK: AreaList convenience initializers and mutators

extension AreaList {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AreaList.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        isExpanded: Bool?? = nil,
        areaName: String?? = nil,
        shopList: [String]?? = nil
    ) -> AreaList {
        return AreaList(
            isExpanded: isExpanded ?? self.isExpanded,
            areaName: areaName ?? self.areaName,
            shopList: shopList ?? self.shopList
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

//Mock Data
//        let modTN = StateList.init(stateName: "Tamil Nadu State", districtList: [DistrictList.init(districtName: "Chennai District", areaList: [AreaList.init(areaName: "Tnagar Area", shopList: ["GRT","Lalitha","Chennai Silks"])])])
//        let modDelhi = StateList.init(stateName: "Delhi State", districtList: [DistrictList.init(districtName: "New Delhi District", areaList: [AreaList.init(areaName: "Agara Area", shopList: ["Statue","River","Photo","Camel","Car"])])])
//        let modKerala = StateList.init(stateName: "Kerala State", districtList: [DistrictList.init(districtName: "Kollam District", areaList: [AreaList.init(areaName: "Allepey Area", shopList: ["Boat","Black Water"])]),DistrictList.init(districtName: "Tiruvanthapuram District", areaList: [AreaList.init(areaName: "Capital Area", shopList: ["Palace","Temple"]),AreaList.init(areaName: "Border Area", shopList: ["Trees","Sea","Mountains"])])])
//        let arrayModelbefore = [modKerala,modTN,modDelhi]
        
