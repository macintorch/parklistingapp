# LoadingViewController

[![Build Status](https://travis-ci.org/iSapozhnik/LoadingViewController.svg?style=flat)](https://travis-ci.org/iSapozhnik/LoadingViewController)
[![Version](https://img.shields.io/cocoapods/v/LoadingViewController.svg?style=flat)](http://cocoapods.org/pods/LoadingViewController)
[![License](https://img.shields.io/cocoapods/l/LoadingViewController.svg?style=flat)](http://cocoapods.org/pods/LoadingViewController)
[![Platform](https://img.shields.io/cocoapods/p/LoadingViewController.svg?style=flat)](http://cocoapods.org/pods/LoadingViewController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

LoadingViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LoadingViewController"
```

UITableViewController and UICollectionViewController are not supported yet. 

## How to use

Subclass your controller from LoadingViewController. On the top of View of your controller put another UIView which will be content view. All your content should be on the top of Content view. Link *_contentView_* property with this newly created view.

```swift
override func viewDidLoad() {
	super.viewDidLoad()
	
	setVisibleScreen(.Loading)
	APIService.fetchSomeData({ response in
		// Update UI
		self.setVisibleScreen(.Content)
	}) 
}
```

## TODO
* add support of UITableViewController and UICollectionViewController
* implement NoData view, Empty view
* fix autolayout issues
* add pull to refresh and load more features
* code refactoring :)

## Author

Sapozhnik Ivan, sapozhnik.ivan@gmail.com

## License

LoadingViewController is available under the MIT license. See the LICENSE file for more info.
