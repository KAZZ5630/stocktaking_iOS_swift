import UIKit

class ShowStockController: UIViewController {
    private let stockModel: ShowStockModel
    private let colors: ColorTheme
    private let inventoryDatasource = InventoryDatasource()
    let placeID: Int
    let placeNM: String
    
    private var showStockView: ShowStockView! {
        return view as? ShowStockView
    }
    
    init(id: Int, name: String, vm: ShowStockModel, col: ColorTheme) {
        self.placeID = id
        self.placeNM = name
        self.stockModel = vm
        self.colors = col
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- load view
    override func loadView() {
        view = ShowStockView(theme: colors, place: placeNM)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewActions()
        setupTableView()
        stockModel.delegate = self
        stockModel.getInventoryList(inventoryList: inventoryDatasource, place: self.placeID)
        stockModel.loadTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showStockView.reload(getSafeAreaFrame())
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onOrientationChange(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc func onOrientationChange(notification: NSNotification){
        showStockView?.reload(getSafeAreaFrame())
    }
    
    private func getSafeAreaFrame() -> ScreenSize {
        var lPadding: CGFloat = 0.0
        var rPadding: CGFloat = 0.0
        var tPadding: CGFloat = 0.0
        var bPadding: CGFloat = 0.0
        
        if #available(iOS 13, *) {
            let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?
                .windows
                .filter({$0.isKeyWindow})
                .first
            
            if let w = window {
                lPadding = w.safeAreaInsets.left
                rPadding = w.safeAreaInsets.right
                tPadding = w.safeAreaInsets.top
                bPadding = w.safeAreaInsets.bottom
            }
        }
        
        let frame: ScreenSize = ScreenSize(
            top: tPadding,
            left: lPadding,
            width: view.frame.size.width - lPadding - rPadding,
            height: view.frame.size.height - tPadding - bPadding
        )
        return frame
    }
    
    //MARK:- settings
    private func setupTableView() {
        showStockView.stockTableView.register(ShowStockCell.self, forCellReuseIdentifier: "ShowStockCell")
        showStockView.stockTableView.rowHeight = UITableView.automaticDimension
        showStockView.stockTableView.estimatedRowHeight = 100
        showStockView.stockTableView.separatorStyle = .singleLine
        showStockView.stockTableView.delegate = self
        showStockView.stockTableView.dataSource = self
    }
    
    private func setupViewActions() {
        showStockView?.backButton.addTarget(
            self,
            action: #selector(onBackButtonTapped),
            for: .touchUpInside
        )
        showStockView?.registerButton.addTarget(
            self,
            action: #selector(onRegisterButtonTapped),
            for: .touchUpInside
        )
        showStockView.refreshButton.addTarget(
            self,
            action: #selector(onRefreshButtonTapped),
            for: .touchUpInside
        )
    }
    
    //MARK:- button action
    @objc func onBackButtonTapped() {
        let nextView = stockModel.backButtonTapped()
        nextView.modalTransitionStyle = .crossDissolve
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView,animated: true, completion: nil)
    }
    
    @objc func onRegisterButtonTapped() {
        stockModel.onRegisterButtonTapped(placeId: placeID)
    }
    
    @objc func onRefreshButtonTapped() {
        inventoryDatasource.removeAll()
        stockModel.onRefreshButtonTapped(list: inventoryDatasource, id: placeID)
    }
}

//MARK:- tableView
extension ShowStockController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ShowStockHeader().getHeaderView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockModel.inventoryArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let data = stockModel.inventoryArray[indexPath.row]
        if data.actual != data.logical {
            cell.backgroundColor = colors.highlightedColor
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowStockCell", for: indexPath) as! ShowStockCell
        cell.selectionStyle = .none
        cell.configure(withTheme: colors)
        cell.bind(with: stockModel.inventoryArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) was selected")
        showStockView.showAlert(vm: stockModel, rowNumber: indexPath.row)
    }
}

//MARK:- delegate
extension ShowStockController: ShowStockModelDelegate {
    func reloadTable() {
        print("ShowStockController.reloadTable()")
        showStockView.stockTableView.reloadData()
    }
    
    func updateInventoryArray(_ list: InventoryDatasource) {
        print("ShowStockContoller.updateInventoryArray()")
        var array: [Inventory] = []
        for index in 0..<list.shNms.count {
            let item = Inventory(productID: list.shIds[index], product: list.shNms[index], logical: list.logicals[index], actual: list.actuals[index])
            array.append(item)
        }
        stockModel.setInventoryArray(array)
        reloadTable()
    }
    
    func alertRegistrationFailed() {
        let alert = UIAlertController(
            title: "登録失敗",
            message: "時間をおいて再実行、またはアプリの再起動をお試しください。",
            preferredStyle:  UIAlertController.Style.alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.cancel,
                handler:nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    func alertRegistrationSucceed() {
        let alert = UIAlertController(
            title: "登録成功",
            message: "入力内容を登録しました",
            preferredStyle:  UIAlertController.Style.alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.cancel,
                handler:nil
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    func alertError(_ err: NSError) {
        let networkErrorAlert = NetworkErrorAlertController()
        present(networkErrorAlert.getAlert(err), animated: true, completion: nil)
    }
}
