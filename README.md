# Keyboardable
iOS Keyboard Observer Protocol

#### Use

```Swift
import UIKit

class mainVC: UIViewController, Keyboardable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardObserver { (height) in
            //code
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}//
```

## License
Usage is provided under the [MIT License](http://http//opensource.org/licenses/mit-license.php). See LICENSE for the full details.
