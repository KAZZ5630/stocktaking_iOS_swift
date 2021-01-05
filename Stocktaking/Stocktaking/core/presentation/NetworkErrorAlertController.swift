import UIKit

class NetworkErrorAlertController {
    
    func getAlert(_ err: NSError) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(
            title: "ネットワークエラーが発生しました",
            message: "code: \(err.code)\n \(err.localizedDescription)\n",
            preferredStyle:  UIAlertController.Style.alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler:nil
            )
        )
        return alert
    }
}
