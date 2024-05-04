/// A musical key.
enum Key: String {
    // Major
    case c = "C"
    case g = "G"
    case d = "D"
    case a = "A"
    case e = "E"
    case b = "B"
    case fSharpGFlat = "F♯/G♭"
    case dFlat = "D♭"
    case aFlat = "A♭"
    case eFlat = "E♭"
    case bFlat = "B♭"
    case f = "F"

    // Minor
    case aMinor = "Am"
    case eMinor = "Em"
    case bMinor = "Bm"
    case fSharpMinor = "F♯m"
    case cSharpMinor = "C♯m"
    case gSharpMinor = "G♯m"
    case dSharpMinorEFlatMinor = "D♯m/E♭m"
    case bFlatMinor = "B♭m"
    case fMinor = "Fm"
    case cMinor = "Cm"
    case gMinor = "Gm"
    case dMinor = "Dm"
}

extension Key {
    /// The key in Camelot (aka. Lancelot) notation.
    var camelot: String {
        switch self {
        // Major
        case .c: "8B"
        case .g: "9B"
        case .d: "10B"
        case .a: "11B"
        case .e: "12B"
        case .b: "1B"
        case .fSharpGFlat: "2B"
        case .dFlat: "3B"
        case .aFlat: "4B"
        case .eFlat: "5B"
        case .bFlat: "6B"
        case .f: "7B"

        // Minor
        case .aMinor: "8A"
        case .eMinor: "9A"
        case .bMinor: "10A"
        case .fSharpMinor: "11A"
        case .cSharpMinor: "12A"
        case .gSharpMinor: "1A"
        case .dSharpMinorEFlatMinor: "2A"
        case .bFlatMinor: "3A"
        case .fMinor: "4A"
        case .cMinor: "5A"
        case .gMinor: "6A"
        case .dMinor: "7A"
        }
    }

    /// The key in mixed Traditional/Camelot notation.
    var mixed: String {
        "\(camelot) (\(rawValue))"
    }
}
