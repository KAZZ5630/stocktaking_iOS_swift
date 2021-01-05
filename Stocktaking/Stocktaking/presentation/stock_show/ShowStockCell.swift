import UIKit

struct Inventory {
    var productID: Int
    var product: String
    var logical: Float
    var actual: Float
}

class ShowStockCell: UITableViewCell {
    private let productLabel: UILabel = createProductLabel()
    private let logicalLabel: UILabel = createStockLabel()
    private let actualLabel: UILabel = createStockLabel()
    private let bodyStackView: UIStackView = createHorizontalStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with source: Inventory) {
        productLabel.text = source.product
        logicalLabel.text = String(source.logical)
        actualLabel.text = String(source.actual)
    }
    
    func configure(withTheme theme: ColorTheme) {
        backgroundColor = theme.transparent
        productLabel.textColor = theme.foregroundColor
        logicalLabel.textColor = theme.foregroundColor
        actualLabel.textColor = theme.foregroundColor
        productLabel.backgroundColor = theme.transparent
        logicalLabel.backgroundColor = theme.transparent
        actualLabel.backgroundColor = theme.transparent
    }
    
    //MARK:- setups
    private func setup() {
        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        addSubview(bodyStackView)
        bodyStackView.addArrangedSubview(productLabel)
        bodyStackView.addArrangedSubview(logicalLabel)
        bodyStackView.addArrangedSubview(actualLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // horizontal
            bodyStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bodyStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logicalLabel.widthAnchor.constraint(equalToConstant: 100),
            actualLabel.widthAnchor.constraint(equalToConstant: 100),
            // vertical
            bodyStackView.topAnchor.constraint(equalTo: topAnchor),
            bodyStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
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
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}
