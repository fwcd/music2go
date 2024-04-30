extension String {
    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
