import UIKit

struct InventoryHeader {
    var productTitle: String
    var logicalTitle: String
    var actualTitle: String
}

class ShowStockHeader: UITableViewHeaderFooterView{
    private let leftPaddingLabel: UILabel = createStockLabel()
    private let productTitleLabel: UILabel = createProductLabel()
    private let logicalTitleLabel: UILabel = createStockLabel()
    private let actualTitleLabel: UILabel = createStockLabel()
    private let headerStackView: UIStackView = createHorizontalStackView()
    let colors: ColorTheme = ColorTheme.mainTheme()
    
    init() {
        super.init(reuseIdentifier: "stockHeader")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerText: InventoryHeader = InventoryHeader(
        productTitle: "商品名",
        logicalTitle: "理論在庫",
        actualTitle: "実在庫"
    )
    
    func getHeaderView() -> UIStackView {
        bindText()
        setupViewHierarchy()
        setupColor()
        setupConstraints()
        return headerStackView
    }
    
    private func bindText() {
        leftPaddingLabel.text = " "
        productTitleLabel.text = self.headerText.productTitle
        logicalTitleLabel.text = self.headerText.logicalTitle
        actualTitleLabel.text = self.headerText.actualTitle
    }
    
    private func setupViewHierarchy() {
        headerStackView.addArrangedSubview(leftPaddingLabel)
        headerStackView.addArrangedSubview(productTitleLabel)
        headerStackView.addArrangedSubview(logicalTitleLabel)
        headerStackView.addArrangedSubview(actualTitleLabel)
    }
    
    private func setupColor() {
        headerStackView.backgroundColor = colors.lightBgColor
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // horizontal
            actualTitleLabel.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor),
            logicalTitleLabel.trailingAnchor.constraint(equalTo: actualTitleLabel.leadingAnchor),
            logicalTitleLabel.widthAnchor.constraint(equalToConstant: 100),
            actualTitleLabel.widthAnchor.constraint(equalToConstant: 100),
            leftPaddingLabel.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
        
    //MARK:- settings
    private static func createProductLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private static func createStockLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private static func createHorizontalStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }
}
