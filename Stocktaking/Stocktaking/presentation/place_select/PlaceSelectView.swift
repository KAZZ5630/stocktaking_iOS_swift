import UIKit

class PlaceSelectView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    var colorTheme: ColorTheme
    
    let placeTextField: UITextField = createPlaceTextField()
    let searchButton: UIButton = createSearchButton()
    let logoutButton: UIButton = createLogoutButton()
    private let pickPlaceLabel: UILabel = createPickPlaceLabel()
    private let toolbar:UIToolbar = createToolbar()
    var placePickerView: UIPickerView = UIPickerView()
    
    var listForPicker: [String] = []
    
    init(theme colorTheme:ColorTheme) {
        self.colorTheme = colorTheme
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- settings
    func setListForPicker(_ list: [String]) {
        self.listForPicker = list
    }
    
    func setup() {
        setupColors()
        setupViewHierarchy()
        setupConstraints()
        placePickerView.delegate = self
        placePickerView.dataSource = self
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)

        self.placeTextField.inputView = placePickerView
        self.placeTextField.inputAccessoryView = toolbar
    }
    
    private func setupColors() {
        backgroundColor = colorTheme.backgroundColor
        pickPlaceLabel.textColor = colorTheme.foregroundColor
        placeTextField.textColor = colorTheme.foregroundColor
        placeTextField.backgroundColor = colorTheme.textFieldBgColor
        searchButton.backgroundColor = colorTheme.lightBgColor
        logoutButton.backgroundColor = colorTheme.lightBgColor
    }
    
    private func setupViewHierarchy() {
        addSubview(placeTextField)
        addSubview(searchButton)
        addSubview(logoutButton)
        addSubview(pickPlaceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // vertical
            pickPlaceLabel.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.centerYAnchor,
                constant: -100.0
            ),
            placeTextField.topAnchor.constraint(
                equalTo: pickPlaceLabel.bottomAnchor,
                constant: 24.0
            ),
            placeTextField.heightAnchor.constraint(
                equalToConstant: 50
            ),
            searchButton.topAnchor.constraint(
                equalTo: placeTextField.bottomAnchor,
                constant: 35
            ),
            searchButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
            logoutButton.topAnchor.constraint(
                equalTo: searchButton.bottomAnchor,
                constant: 35
            ),
            logoutButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
            // horizontal
            pickPlaceLabel.centerXAnchor.constraint(
                equalTo: layoutMarginsGuide.centerXAnchor
            ),
            placeTextField.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor
            ),
            placeTextField.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor
            ),
            searchButton.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor
            ),
            searchButton.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor
            ),
            logoutButton.leadingAnchor.constraint(
                equalTo: layoutMarginsGuide.leadingAnchor
            ),
            logoutButton.trailingAnchor.constraint(
                equalTo: layoutMarginsGuide.trailingAnchor
            ),

        ])
    }
    
    //MARK:- create objects
    private static func createPickPlaceLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "PICK YOUR PLACE"
        view.textAlignment = .center
        return view
    }
    
    private static func createPlaceTextField() -> UITextField {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "place..."
        view.borderStyle = .roundedRect
        view.backgroundColor = .clear
        return view
    }
    
    private static func createSearchButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("SEARCH", for: .normal)
        return view
    }
    
    private static func createLogoutButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("log out", for: .normal)
        return view
    }
    
    private static func createToolbar() -> UIToolbar {
        let view: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width:100, height: 40))
        return view
    }
    
    //MARK:- PickerView properties
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listForPicker.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listForPicker[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.placeTextField.text = listForPicker[row]
    }

    @objc func cancel() {
        self.placeTextField.text = ""
        self.placeTextField.endEditing(true)
    }

    @objc func done() {
        self.placeTextField.endEditing(true)
    }

}
