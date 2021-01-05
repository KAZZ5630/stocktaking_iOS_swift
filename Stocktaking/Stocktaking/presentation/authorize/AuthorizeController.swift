import UIKit
import LocalAuthentication

class AuthorizeController: UIViewController {
    private let colors: ColorTheme = ColorTheme.mainTheme()
    private let authorizeModel = AuthorizeModel(webService: WebServiceImp())
    
    private var authorizeView: AuthorizeView! {
        return view as? AuthorizeView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK:- load View
    override func loadView() {
        view = AuthorizeView(theme: colors)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewActions()
    }
    
    private func setupViewActions() {
        authorizeView?.loginButton.addTarget(
            self,
            action: #selector(enterButtonTapped),
            for: .touchUpInside
        )
    }
    
    //MARK:- button action
    @objc func enterButtonTapped() {
        print("AuthorizeController.enterButtonTapped()")
        let context = LAContext()
        let reason = "This app uses local authentication to secure your data."
        var authError: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    print("Authenticated. success:\(success), error:\(error.debugDescription)")
                    DispatchQueue.main.async {
                        self.moveToNextView()
                    }
                } else {
                    guard let err = error as NSError? else {
                        print("evaluate failed: \(error.debugDescription)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.authorizeView.showAlert(
                            title: "認証を中断しました",
                            msg: self.getErrorMessage(err)
                        )
                    }
                }
            }
        } else {
            let title = "生体認証が利用できません"
            let errMsg = authError?.localizedDescription ?? "canEvaluatePolicy returned false"
            let message = "端末の設定内容をご確認ください。\n\(errMsg)"
            DispatchQueue.main.async {
                self.authorizeView.showAlert(title: title, msg: message)
            }
        }
    }
    
    private func getErrorMessage(_ err: NSError) -> String {
        var message = "code \(err.code): \(err.localizedDescription)\n"
        switch err.code {
        case -1:
            message = message + "生体認証に必要な情報を取得できませんでした"
        case -9:
            message = message + "アプリ側でキャンセルされました"
        case -10:
            message = message + "予期せぬエラーが発生しています"
        case -1004:
            message = message + "認証は利用できません"
        case -5:
            message = message + "端末にパスコードがセットされていません"
        case -4:
            message = message + "システムで認証がキャンセルされました"
        case -8:
            message = message + "FaceID/TouchIDがロックアウトされました"
        case -6:
            message = message + "この端末ではFaceID/TouchIDを使用できません"
        case -7:
            message = message + "認証に失敗しました"
        case -2:
            message = message + "認証のキャンセルを受け付けました"
        case -3:
            message = message + "認証に失敗しました"
        default:
            message = message + "エラーが発生しています"
        }
        return message
    }

    private func moveToNextView() {
        let nextView = authorizeModel.enterButtonTapped()
        nextView.modalTransitionStyle = .crossDissolve
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView,animated: true, completion: nil)
    }

}

