//
//  WordResponse.swift
//  SkyengTestApp
//
//  Created by Evgeniya Bubnova on 19.08.2020.
//  Copyright © 2020 Evgeniya Bubnova. All rights reserved.
//

import Foundation

struct WordResponse: Decodable {
    var id: Int
    var text: String
    var meanings: [MeaningResponse]
    
}

struct TranslationResponse: Decodable {
    var text: String?
    var note: String?
}

struct MeaningResponse: Decodable {
    enum SpeechCode: String, Decodable {
        case noun = "n"
        case verb = "v"
        case adjective = "j"
        case adverb = "r"
        case preposition = "prp"
        case pronoun = "prn"
        case cardinalNumber = "crd"
        case conjunction = "cjc"
        case interjection = "exc"
        case article = "det"
        case abbreviation = "abb"
        case particle = "x"
        case ordinalNumber = "ord"
        case modalVerb = "md"
        case phrase = "ph"
        case idiom = "phi"
        
        var localizedValue: String {
            switch self {
            case .noun:
                return LS("noun")
            case .verb:
                return LS("verb")
            case .adjective:
                return LS("adjective")
            case .adverb:
                return LS("adverb")
            case .preposition:
                return LS("preposition")
            case .pronoun:
                return LS("pronoun")
            case .cardinalNumber:
                return LS("cardinalNumber")
            case .conjunction:
                return LS("conjunction")
            case .interjection:
                return LS("interjection")
            case .article:
                return LS("article")
            case .abbreviation:
                return LS("abbreviation")
            case .particle:
                return LS("particle")
            case .ordinalNumber:
                return LS("ordinalNumber")
            case .modalVerb:
                return LS("modalVerb")
            case .phrase:
                return LS("phrase")
            case .idiom:
                return LS("idiom")
            }
        }
    }
    var id: Int
    var partOfSpeechCode: SpeechCode?
    var translation: TranslationResponse?
    var previewUrl: String?
    var imageUrl: String?
    var transcription: String?
    var soundUrl: String?
}
