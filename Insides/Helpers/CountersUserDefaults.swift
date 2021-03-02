//import Foundation
//
//class CountersUserDefaults: NSObject, NSCoding {
//
//    var latitude: Double
//    var longitude: Double
//    var name: String
//
//    init(latitude: Double, longitude: Double, name: String) {
//        self.latitude = latitude
//        self.longitude = longitude
//        self.name = name
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        self.latitude = aDecoder.decodeDouble(forKey: "latitude")
//        self.longitude = aDecoder.decodeDouble(forKey: "longitude")
//        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(latitude, forKey: "latitude")
//        aCoder.encode(longitude, forKey: "longitude")
//        aCoder.encode(name, forKey: "name")
//    }
//}
//
//func savePlaces() {
//
//    var placesArray: [Place] = []
//    placesArray.append(Place(latitude: 12, longitude: 21, name: "place 1"))
//    placesArray.append(Place(latitude: 23, longitude: 32, name: "place 2"))
//    placesArray.append(Place(latitude: 34, longitude: 43, name: "place 3"))
//
//    do {
//        let placesData = try NSKeyedArchiver.archivedData(withRootObject: placesArray, requiringSecureCoding: false)
//        UserDefaults.standard.set(placesData, forKey: "places")
//    } catch {
//        print(error.localizedDescription)
//    }
//
//}
//
//func loadPlaces() {
//
//    guard let placesData = UserDefaults.standard.object(forKey: "places") as? NSData else {
//        print("'places' not found in UserDefaults")
//        return
//    }
//
//    do {
//        guard let placesArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(placesData as Data) as? [Place] else { return }
//        for place in placesArray {
//            print("place.latitude: \(place.latitude)")
//            print("place.longitude: \(place.longitude)")
//            print("place.name: \(place.name)")
//        }
//    } catch {
//        print(error.localizedDescription)
//    }
//
//}
