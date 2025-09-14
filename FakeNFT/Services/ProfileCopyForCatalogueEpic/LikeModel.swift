// TODO: Копия реализации Амины.
//       Помнить про это при слиянии.


struct LikeModel: Dto {
    let nftId: String
    let isLiked: Bool
    
    func asDictionary() -> [String: String] {
        return [
            "nft_id": nftId,
            "is_liked": isLiked ? "true" : "false"
        ]
    }
}
