// TODO: Измененная копия реализации Амины.
//       Помнить про это при слиянии.


struct LikeModel: Dto {
    let likes: [String]
    
    enum CodingKeys: String, CodingKey {
        case likes
    }

    func asDictionary() -> [String: String] {
        let likesString = likes.joined(separator: ",")
        return [
            CodingKeys.likes.rawValue: likesString
        ]
    }
}
