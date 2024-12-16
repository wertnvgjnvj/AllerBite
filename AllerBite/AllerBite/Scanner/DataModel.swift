import Foundation

struct User: Codable, Identifiable,Equatable {
    var id: String
    var username: String
    var email: String
    var allergies: [String]
    var veg: String
    var isVerified:Bool

    init(id: String, username: String, email: String, allergies: [String] = [], veg
    : String,isVerified:Bool) {
        self.id = id
        self.username = username
        
        self.email = email
        self.allergies = allergies
        self.veg = veg
        self.isVerified = isVerified
    }
}

class HomeScreenPreferences {
    var allergenPreference: Bool
    var foodPreference: FoodType
    
    init(allergenPreference: Bool, foodPreference: FoodType) {
        self.allergenPreference = allergenPreference
        self.foodPreference = foodPreference
    }
}

enum FoodType {
    case vegetarian
    case nonVegetarian
    case healthConscious
}


struct ProductNamespace {
    class Ingredient {
        var name: String
        var isAllergen: Bool
        
        init(name: String, isAllergen: Bool) {
            self.name = name
            self.isAllergen = isAllergen
        }
    }
}



class HomeViewModel {
    var userPreferences: HomeScreenPreferences
    
    init(userPreferences: HomeScreenPreferences) {
        self.userPreferences = userPreferences
    }
    
    func checkProductCompatibility(product: ScannerData) -> Bool {
        let isAllergenFree = !product.ingredients.contains { $0.isAllergen }
        let isFoodTypeCompatible = isCompatibleFoodType(foodType: product.foodType)
        
        return isAllergenFree && isFoodTypeCompatible
    }
    
    private func isCompatibleFoodType(foodType: FoodType) -> Bool {
        switch userPreferences.foodPreference {
        case .vegetarian:
            return foodType == .vegetarian || foodType == .healthConscious
        case .nonVegetarian:
            return foodType == .nonVegetarian || foodType == .healthConscious
        case .healthConscious:
            return true
        }
    }
}


class ScannerData {
    var productName: String
    var ingredients: [ProductNamespace.Ingredient]
    var foodType: FoodType 
    
    init(productName: String, ingredients: [ProductNamespace.Ingredient], foodType: FoodType) {
        self.productName = productName
        self.ingredients = ingredients
        self.foodType = foodType
    }
}

class HealthPlannerData {
    var appointments: [Appointment]
    var medicines: [Medicine]
    var allergenReactions: [AllergenReaction]
    
    init(appointments: [Appointment], medicines: [Medicine], allergenReactions: [AllergenReaction]) {
        self.appointments = appointments
        self.medicines = medicines
        self.allergenReactions = allergenReactions
    }
}

class Appointment {
    var appointmentDate: Date
    var doctor: Doctor
    
    init(appointmentDate: Date, doctor: Doctor) {
        self.appointmentDate = appointmentDate
        self.doctor = doctor
    }
}

class Doctor {
    var name: String
    var specialty: String
    
    init(name: String, specialty: String) {
        self.name = name
        self.specialty = specialty
    }
}

class Medicine {
    var name: String
    var dosage: String
    
    init(name: String, dosage: String) {
        self.name = name
        self.dosage = dosage
    }
}

class AllergenReaction {
    var allergen: Allergen
    var reactionDescription: String
    
    init(allergen: Allergen, reactionDescription: String) {
        self.allergen = allergen
        self.reactionDescription = reactionDescription
    }
}

class Allergen {
    var name: String
    var severity: AllergySeverity
    
    init(name: String, severity: AllergySeverity) {
        self.name = name
        self.severity = severity
    }
}

enum AllergySeverity {
    case mild
    case moderate
    case severe
}

