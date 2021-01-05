import UIKit

class ShowStockView: UIView {
    var colorTheme: ColorTheme
    var place: String
    
    private let placeLabel: UILabel = createPickPlaceLabel()
    let backButton: UIButton = createBackButton()
    let refreshButton: UIButton = createRefreshButton()
    let registerButton: UIButton = createRegisterButton()
    let stockTableView: UITableView = createStockTableView()
    
    init(theme colorTheme: ColorTheme, place: String) {
        self.colorTheme = colorTheme
        self.place = place
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- reload
    func reload(_ safeAreaFrame: ScreenSize) {
        print("ShowStockView.reload()")
        var tableHeight: CGFloat
        if safeAreaFrame.height < safeAreaFrame.width {
            tableHeight = CGFloat(safeAreaFrame.height*0.8)
        } else {
            tableHeight = CGFloat(safeAreaFrame.height*0.85)
        }
        let tableAreaFrame = CGRect(
            x: safeAreaFrame.left,
            y: safeAreaFrame.top+safeAreaFrame.height-tableHeight,
            width: safeAreaFrame.width,
            height: tableHeight
        )
        stockTableView.frame = tableAreaFrame
        stockTableView.setNeedsDisplay()
        stockTableView.reloadData()
    }
    
    //MARK:- settings
    func setup() {
        setupColors()
        setupViewHierarchy()
        setupConstraints()
        placeLabel.text = (place=="") ? "empty" : place
    }
    
    private func setupColors() {
        backgroundColor = colorTheme.backgroundColor
        placeLabel.textColor = colorTheme.foregroundColor
        backButton.backgroundColor = colorTheme.transparent
        backButton.setTitleColor(colorTheme.foregroundColor, for: .normal)
        refreshButton.backgroundColor = colorTheme.transparent
        refreshButton.setTitleColor(colorTheme.foregroundColor, for: .normal)
        registerButton.backgroundColor = colorTheme.transparent
        registerButton.setTitleColor(colorTheme.foregroundColor, for: .normal)
        stockTableView.separatorColor = colorTheme.lightBgColor
        stockTableView.backgroundColor = colorTheme.transparent
    }
    
    private func setupViewHierarchy() {
        addSubview(placeLabel)
        addSubview(backButton)
        addSubview(refreshButton)
        addSubview(registerButton)
        addSubview(stockTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // vertical
            placeLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 10.0
            ),
            backButton.bottomAnchor.constraint(
                equalTo: stockTableView.topAnchor,
                constant: 0.0),

            registerButton.centerYAnchor.constraint(
                equalTo: backButton.centerYAnchor,
                constant: 0.0
            ),
            refreshButton.centerYAnchor.constraint(
                equalTo: backButton.centerYAnchor,
                constant: 0.0
            ),
            placeLabel.heightAnchor.constraint(
                equalToConstant: 50
            ),
            backButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
            registerButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
            refreshButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
            // horizontal
            placeLabel.centerXAnchor.constraint(
                equalTo: layoutMarginsGuide.centerXAnchor
            ),
            backButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            registerButton.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            refreshButton.trailingAnchor.constraint(
                equalTo: registerButton.leadingAnchor,
                constant: -20
            ),
        ])
    }
    
    //MARK:- create objects
    private static func createPickPlaceLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "PLACE"
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 30)
        return view
    }
    
    private static func createBackButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("< back", for: .normal)
        return view
    }
    
    private static func createRefreshButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("再取得", for: .normal)
        return view
    }
    
    private static func createRegisterButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("登録", for: .normal)
        return view
    }
    
    private static func createStockTableView() -> UITableView {
        let view = UITableView()
        return view
    }
    
    //MARK:- Alert
    func showAlert(vm: ShowStockModel, rowNumber: Int) {
        
        let source = vm.inventoryArray[rowNumber]
        
        let alert: UIAlertController = UIAlertController(
            title: "実在庫編集",
            message: "\(source.product)\n理論在庫：\(source.logical)",
            preferredStyle:  UIAlertController.Style.alert
        )
        
        alert.addTextField(configurationHandler: {
            $0.placeholder = "number..."
            $0.text = ""
            $0.tag = 1
            $0.keyboardType = .decimalPad
        })
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler:{
                    (action: UIAlertAction!) -> Void in
                    guard let textFields = alert.textFields else { return }
                    if textFields.isEmpty { return }

                    var inputActualStock: Float = source.actual
                    for t in textFields {
                        if t.tag == 1 {
                            if let num = Float(t.text!) {
                            inputActualStock = num
                            } else {
                                print("invalid value")
                                return
                            }
                        }
                    }
                    
                    print("input text: \(inputActualStock)\n")
                    vm.editActualStockAndReload(row: rowNumber, actual: inputActualStock)
                })
        )
        
        alert.addAction(
            UIAlertAction(
                title: "cancel",
                style: UIAlertAction.Style.cancel,
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
