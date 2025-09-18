// TODO: Копия реализации Амины со следующими изменениями:
//
//       - Переименован из SortType в ProfileSortType из-за конфликта с
//         StatisticsPresenter.
//
//       Помнить про это при слиянии.

enum ProfileSortType: String {
    case byName
    case byAmount
    case byPrice
    case byRating
    case byFirstName
}
