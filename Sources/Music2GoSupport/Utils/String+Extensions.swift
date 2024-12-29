extension String {
    public var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
