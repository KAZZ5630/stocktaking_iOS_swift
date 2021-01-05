import UIKit

class PlaceSelectController: UIViewController, PlaceSelectModelDelegate, UIPickerViewDelegate {
    private let colors: ColorTheme = ColorTheme.mainTheme()
    private let placeSelectModel = PlaceSelectModel(webService: WebServiceImp())
    private let placeDataSource = PlaceSelectDataSource()
    
    private var placeSelectView: PlaceSelectView? {
        return view as? PlaceSelectView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK:- load View
    override func loadView() {
        view = PlaceSelectView(theme: colors)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewActions()
        placeSelectModel.delegate = self
        placeSelectModel.getPlaceList(placeList: self.placeDataSource)
    }
    
    private func setupViewActions() {
        placeSelectView?.searchButton.addTarget(
            self,
            action: #selector(searchButtonTapped),
            for: .touchUpInside
        )
        placeSelectView?.logoutButton.addTarget(
            self,
            action: #selector(logoutButtonTapped),
            for: .touchUpInside
        )
    }
    
    //MARK:- button actions
    @objc func searchButtonTapped() {
        guard let place = placeSelectView?.placeTextField.text else { return }
        if place == "" {
            return
        }
        guard let index = placeDataSource.items.firstIndex(of: place) else { return }
        let nextView = placeSelectModel.searchButtonTapped(placeID: placeDataSource.ids[index], placeNM: place, color: colors)
        nextView.modalTransitionStyle = .crossDissolve
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated: true, completion: nil)
    }
    
    @objc func logoutButtonTapped() {
        print("logout button tapped")
        let nextView = placeSelectModel.backToPreviousView()
        nextView.modalTransitionStyle = .crossDissolve
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView,animated: true, completion: nil)
    }
    
    //MARK:- delegate
    func reloadPlaceList(_ placeList: PlaceSelectDataSource) {
        print("delegate: reloadPlaceList()")
        placeSelectView?.setListForPicker(placeList.items)
        placeSelectView?.placePickerView.reloadAllComponents()
    }
    
    func alertError(_ err: NSError) {
        let networkErrorAlert = NetworkErrorAlertController()
        present(networkErrorAlert.getAlert(err), animated: true, completion: nil)
    }
    
}
