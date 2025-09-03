import UIKit

extension UITableView {
    func reuse<T: UITableViewCell & ReuseIdentifying>(
        _ type: T.Type,
        indexPath: IndexPath
    ) -> T? {
        dequeueReusableCell(
            withIdentifier: T.defaultReuseIdentifier,
            for: indexPath
        ) as? T
    }
}
