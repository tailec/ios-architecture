# mvvm-rxswift-subjects-observables
This example uses RxSwift observables and subjects as binding mechanism between `ViewModel` and `ViewController`.


## Implementation
The following image illustrates the bindings:


![scenario](example-scenario.png)

- `ViewModel` **inputs** such as text field changes or `UITableView` row selection are defined as subjects `ViewModel`
- `ViewModel` **outputs** are defined as `Driver` traits


## Installation
Clone the repository:

`git clone git@github.com:tailec/ios-architecture.git`

Checkout `mvvm-rxswift-subjects-observables` branch:

`git checkout mvvm-rxswift-subjects-observables`


Install dependencies:

 `pod install`
