# MVP
This example uses standard iOS MVP pattern.


## Implementation
The following image illustrates the bindings:


![scenario](example-scenario.png)

- `ViewModel` **inputs** such as text field changes or `UITableView` row selection are defined as swift functions that are called in `ViewController`
- `ViewModel` **outputs** are sending data to `ViewController` using delegation pattern

## Installation
Clone the repository:

`git clone git@github.com:tailec/ios-architecture.git`

Navigate to  `mvp` directory:

`cd mvp`

No `pod install` is required in this example.
