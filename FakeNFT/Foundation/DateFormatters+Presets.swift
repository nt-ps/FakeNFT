import Foundation

extension DateFormatter {
    static var defaultDateFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
        dateFormatter.formatOptions.insert(.withTimeZone)
        return dateFormatter
    } ()
}
