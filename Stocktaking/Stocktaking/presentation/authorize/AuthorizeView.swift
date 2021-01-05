import UIKit

class AuthorizeView: UIView {

    var colorTheme: ColorTheme
    
    let loginButton: UIButton = createLoginButton()
    private let iconImage: UIView = createIconImage()
        
    init(theme colorTheme:ColorTheme) {
        self.colorTheme = colorTheme
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- settings
    func setup() {
        setupColors()
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupColors() {
        backgroundColor = colorTheme.backgroundColor
        loginButton.backgroundColor = colorTheme.lightBgColor
    }
    
    private func setupViewHierarchy() {
        addSubview(loginButton)
        addSubview(iconImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // vertical
            iconImage.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.centerYAnchor,
                constant: 0
            ),
            iconImage.heightAnchor.constraint(
                equalToConstant: 150
            ),
            loginButton.topAnchor.constraint(
                equalTo: iconImage.bottomAnchor,
                constant: 35
            ),
            loginButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
            // horizontal
            iconImage.centerXAnchor.constraint(
                equalTo: layoutMarginsGuide.centerXAnchor
            ),
            iconImage.widthAnchor.constraint(
                equalToConstant: 150
            ),
            loginButton.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor
            ),
            loginButton.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor
            ),
        ])
    }
    
    //MARK:- create objects
    private static func createLoginButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("LOG IN", for: .normal)
        return view
    }
    
    private static func createIconImage() -> UIView {
        let view = UIImageView()
        view.image = UIImage(named: "TopImage")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    //MARK:- alert
    func showAlert(title: String, msg: String) {
        let alert: UIAlertController = UIAlertController(
            title: title,
            message: msg,
            preferredStyle:  UIAlertController.Style.alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler:nil
            )
        )
        var window = UIWindow()
        for win in UIApplication.shared.windows {
            if win.isKeyWindow {
                window = win
            }
        }
        var baseView = window.rootViewController
        while ((baseView?.presentedViewController) != nil)  {
            baseView = baseView?.presentedViewController
        }
        
        baseView?.present(alert, animated: true, completion: nil)
    }
}
