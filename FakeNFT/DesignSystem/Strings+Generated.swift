// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Cart {
    /// The cart is empty
    internal static let empty = L10n.tr("Localizable", "cart.empty", fallback: "The cart is empty")
    /// Price
    internal static let price = L10n.tr("Localizable", "cart.price", fallback: "Price")
    /// To be paid
    internal static let toPayment = L10n.tr("Localizable", "cart.toPayment", fallback: "To be paid")
    internal enum DeleteAlert {
      /// Go back
      internal static let cancel = L10n.tr("Localizable", "cart.deleteAlert.cancel", fallback: "Go back")
      /// Delete
      internal static let delete = L10n.tr("Localizable", "cart.deleteAlert.delete", fallback: "Delete")
      /// Are you sure you want to
      /// delete the object from the trash?
      internal static let message = L10n.tr("Localizable", "cart.deleteAlert.message", fallback: "Are you sure you want to\ndelete the object from the trash?")
    }
  }
  internal enum Catalog {
    /// Open Nft
    internal static let openNft = L10n.tr("Localizable", "catalog.openNft", fallback: "Open Nft")
   internal enum FailureAlert {
     /// Repeat
     internal static let `repeat` = L10n.tr("Localizable", "catalog.failureAlert.repeat", fallback: "Repeat")
     /// Data could not be
     /// retrieved
     internal static let title = L10n.tr("Localizable", "catalog.failureAlert.title", fallback: "Data could not be\nretrieved")
   }
  }
  internal enum EditProfile {
    /// Description
    internal static let description = L10n.tr("Localizable", "editProfile.description", fallback: "Description")
    /// Name
    internal static let name = L10n.tr("Localizable", "editProfile.name ", fallback: "Name")
    /// Website
    internal static let website = L10n.tr("Localizable", "editProfile.website", fallback: "Website")
    internal enum Avatar {
      internal enum Alert {
        /// Cancel
        internal static let cancel = L10n.tr("Localizable", "editProfile.avatar.alert.cancel", fallback: "Cancel")
        /// Edit photo
        internal static let change = L10n.tr("Localizable", "editProfile.avatar.alert.change", fallback: "Edit photo")
        /// Delete photo
        internal static let delete = L10n.tr("Localizable", "editProfile.avatar.alert.delete", fallback: "Delete photo")
        /// Profile photo
        internal static let title = L10n.tr("Localizable", "editProfile.avatar.alert.title", fallback: "Profile photo")
      }
      internal enum ChangeAlert {
        /// Save
        internal static let save = L10n.tr("Localizable", "editProfile.avatar.changeAlert.save", fallback: "Save")
        /// Link to photo
        internal static let title = L10n.tr("Localizable", "editProfile.avatar.changeAlert.title", fallback: "Link to photo")
      }
      internal enum DeleteAlert {
        /// Delete
        internal static let delete = L10n.tr("Localizable", "editProfile.avatar.deleteAlert.delete", fallback: "Delete")
        /// This action cannot be undone
        internal static let message = L10n.tr("Localizable", "editProfile.avatar.deleteAlert.message", fallback: "This action cannot be undone")
        /// Delete profile photo?
        internal static let title = L10n.tr("Localizable", "editProfile.avatar.deleteAlert.title", fallback: "Delete profile photo?")
      }
      internal enum Error {
        /// Invalid URL format
        internal static let invalidURL = L10n.tr("Localizable", "editProfile.avatar.error.invalidURL", fallback: "Invalid URL format")
        /// Failed to update avatar
        internal static let updateFailed = L10n.tr("Localizable", "editProfile.avatar.error.updateFailed", fallback: "Failed to update avatar")
      }
    }
    internal enum SaveAlert {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "editProfile.saveAlert.cancel", fallback: "Cancel")
      /// Log out
      internal static let save = L10n.tr("Localizable", "editProfile.saveAlert.save", fallback: "Log out")
      /// Are you sure you want
      /// to log out?
      internal static let title = L10n.tr("Localizable", "editProfile.saveAlert.title", fallback: "Are you sure you want\nto log out?")
    }
  }
  internal enum Error {
    /// A network error has occurred
    internal static let network = L10n.tr("Localizable", "error.network", fallback: "A network error has occurred")
    /// Repeat
    internal static let `repeat` = L10n.tr("Localizable", "error.repeat", fallback: "Repeat")
    /// Error
    internal static let title = L10n.tr("Localizable", "error.title", fallback: "Error")
    /// An unknown error has occurred
    internal static let unknown = L10n.tr("Localizable", "error.unknown", fallback: "An unknown error has occurred")
    /// Data could not be retrieved
    internal static let data = L10n.tr("Localizable", "error.data", fallback: "Data could not be retrieved")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "error.cancel", fallback: "Cancel")
  }
  internal enum Favoritenft {
    /// Favorites of NFT
    internal static let title = L10n.tr("Localizable", "favoritenft.title", fallback: "Favorites of NFT")
  }
  internal enum FavouriteNFT {
    /// You don't have any NFT favorites yet
    internal static let empty = L10n.tr("Localizable", "favouriteNFT.empty", fallback: "You don't have any NFT favorites yet")
  }
  internal enum MyNFT {
    /// You don't have NFT yet
    internal static let empty = L10n.tr("Localizable", "myNFT.empty", fallback: "You don't have NFT yet")
    /// from
    internal static let from = L10n.tr("Localizable", "myNFT.from", fallback: "from")
    /// Price
    internal static let price = L10n.tr("Localizable", "myNFT.price", fallback: "Price")
    /// My NFTs
    internal static let title = L10n.tr("Localizable", "myNFT.title", fallback: "My NFTs")
  }
  internal enum Payment {
    /// Return to the catalog
    internal static let backToCataloge = L10n.tr("Localizable", "payment.backToCataloge", fallback: "Return to the catalog")
    /// Pay
    internal static let pay = L10n.tr("Localizable", "payment.pay", fallback: "Pay")
    /// Choose a payment method
    internal static let title = L10n.tr("Localizable", "payment.title", fallback: "Choose a payment method")
    internal enum FailureAlert {
      /// Cancellation
      internal static let cancel = L10n.tr("Localizable", "payment.failureAlert.cancel", fallback: "Cancellation")
      /// Repeat
      internal static let `repeat` = L10n.tr("Localizable", "payment.failureAlert.repeat", fallback: "Repeat")
      /// Failed to make
      /// payment
      internal static let title = L10n.tr("Localizable", "payment.failureAlert.title", fallback: "Failed to make\npayment")
    }
    internal enum Success {
      /// Success! The payment has been completed,
      /// congratulations on the purchase!
      internal static let title = L10n.tr("Localizable", "payment.success.title", fallback: "Success! The payment has been completed,\ncongratulations on the purchase!")
    }
    internal enum UserAgreement {
      /// User Agreement
      internal static let link = L10n.tr("Localizable", "payment.userAgreement.link", fallback: "User Agreement")
      /// By making a purchase, you agree to the terms
      internal static let text = L10n.tr("Localizable", "payment.userAgreement.text", fallback: "By making a purchase, you agree to the terms")
    }
  }
  internal enum Profile {
    internal enum Favoritenft {
      /// Favorites of NFT
      internal static let title = L10n.tr("Localizable", "profile.favoritenft.title", fallback: "Favorites of NFT")
    }
    internal enum MyNFT {
      /// My NFTs
      internal static let title = L10n.tr("Localizable", "profile.myNFT.title", fallback: "My NFTs")
    }
  }
  internal enum SortAlert {
    /// By the number of NFTs
    internal static let byAmount = L10n.tr("Localizable", "sortAlert.byAmount", fallback: "By the number of NFTs")
    /// By name
    internal static let byFirstName = L10n.tr("Localizable", "sortAlert.byFirstName", fallback: "By name")
    /// By name
    internal static let byName = L10n.tr("Localizable", "sortAlert.byName", fallback: "By name")
    /// By price
    internal static let byPrice = L10n.tr("Localizable", "sortAlert.byPrice", fallback: "By price")
    /// By rating
    internal static let byRating = L10n.tr("Localizable", "sortAlert.byRating", fallback: "By rating")
    /// Close
    internal static let close = L10n.tr("Localizable", "sortAlert.close", fallback: "Close")
    /// Sorting
    internal static let title = L10n.tr("Localizable", "sortAlert.title", fallback: "Sorting")
  }
  internal enum Statistics {
    /// NFT collection
    internal static let collectionNFT = L10n.tr("Localizable", "statistics.collectionNFT", fallback: "NFT collection")
    /// Go to user website
    internal static let goToWebsite = L10n.tr("Localizable", "statistics.goToWebsite", fallback: "Go to user website")
    internal enum FailureAlert {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "statistics.failureAlert.cancel", fallback: "Cancel")
      /// Repeat
      internal static let `repeat` = L10n.tr("Localizable", "statistics.failureAlert.repeat", fallback: "Repeat")
      /// Data could not be
      /// retrieved
      internal static let title = L10n.tr("Localizable", "statistics.failureAlert.title", fallback: "Data could not be\nretrieved")
    }
  }
  internal enum Tab {
    /// Shopping cart
    internal static let cart = L10n.tr("Localizable", "tab.cart", fallback: "Shopping cart")
    /// Catalog
    internal static let catalog = L10n.tr("Localizable", "tab.catalog", fallback: "Catalog")
    /// Profile
    internal static let profile = L10n.tr("Localizable", "tab.profile", fallback: "Profile")
    /// Statistics
    internal static let statistics = L10n.tr("Localizable", "tab.statistics", fallback: "Statistics")
  }
  internal enum Collection {
    /// Author caption
    internal static let authorCaption = L10n.tr("Localizable", "collection.authorCaption", fallback: "Author caption")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
