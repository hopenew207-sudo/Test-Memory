struct ytAudio: Decodable {
  struct ytaudioobject: Codable {
    var ytvideoId: String          // -> @VariousType needed
    var accffsdytvideoId: String        // -> @VariousType needed
    @BoolValue var showCountytvideoDown: Bool
    @DateValue<TimeIntervalSince1970> var dstart: Date?
    <TimeIntervalSince1970> var end: Date?   // -> should be @DateValue<...> var end: Date?
    var embedstatus: Bool    // -> @BoolValue needed
  }
}
