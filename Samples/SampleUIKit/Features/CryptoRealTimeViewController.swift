import Foundation
import UIKit
class CryptoViewModel {
	private var updateScheduled = false

	struct PairData {
		var price: Double = 0
		var openPrice: Double = 0
		var history: [Double] = []
	}

	let pairs: [(label: String, key: String)] = [
		("BTC/USDT", "btcusdt"),
		("ETH/USDT", "ethusdt"),
		("SOL/USDT", "solusdt"),
		("BNB/USDT", "bnbusdt"),
		("XRP/USDT", "xrpusdt"),
		("ADA/USDT", "adausdt"),
		("DOGE/USDT", "dogeusdt"),
		("AVAX/USDT", "avaxusdt"),
	]

	var selectedPair = "btcusdt" {
		didSet { onUpdate?() }
	}

	private(set) var pairsData: [String: PairData] = [
		"btcusdt": .init(),
		"ethusdt": .init(),
		"solusdt": .init(),
		"bnbusdt": .init(),
		"xrpusdt": .init(),
		"adausdt": .init(),
		"dogeusdt": .init(),
		"avaxusdt": .init(),
	]

	var onUpdate: (() -> Void)?

	private var webSocketTask: URLSessionWebSocketTask?

	func connect() {
		let streams = pairs.map { "\($0.key)@trade" }
			.joined(separator: "/")

		guard
			let url = URL(string: "wss://stream.binance.com:9443/stream?streams=\(streams)")
		else {
			return
		}

		webSocketTask = URLSession.shared.webSocketTask(with: url)
		webSocketTask?.resume()
		receive()
	}

	func disconnect() {
		webSocketTask?.cancel(with: .goingAway, reason: nil)
		webSocketTask = nil
	}

	func percentageChange(for pair: String) -> Double {
		guard
			let data = pairsData[pair], data.openPrice != 0
		else {
			return 0
		}

		return ((data.price - data.openPrice) / data.openPrice) * 100
	}

	private func receive() {
		webSocketTask?.receive { [weak self] result in
			switch result {
			case .success(let message):
				if case .string(let text) = message {
					self?.handleMessage(text)
				}
				self?.receive()
			case .failure(let error):
				print("WebSocket error:", error)
			}
		}
	}

	private func handleMessage(_ text: String) {
		guard
			let data = text.data(using: .utf8),
			let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
			let stream = json["stream"] as? String,
			let tradeData = json["data"] as? [String: Any],
			let priceString = tradeData["p"] as? String,
			let price = Double(priceString)
		else { return }

		let pair = stream.replacingOccurrences(of: "@trade", with: "")

		DispatchQueue.main.async { [weak self] in
			guard let self else { return }

			if self.pairsData[pair]?.openPrice == 0 {
				self.pairsData[pair]?.openPrice = price
			}

			self.pairsData[pair]?.price = price
			self.pairsData[pair]?.history.append(price)

			if let count = self.pairsData[pair]?.history.count, count > 100 {
				self.pairsData[pair]?.history.removeFirst()
			}

			guard !self.updateScheduled else { return }
			self.updateScheduled = true

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
				self?.updateScheduled = false
				self?.onUpdate?()
			}
		}
	}
}

class CryptoRealTimeViewController: UIViewController {
	private let viewModel = CryptoViewModel()

	private let priceLabel = UILabel()
	private let changeLabel = UILabel()
	private let chartView = LineChartView()

	private let sectionLabel = UILabel()
	private let searchBar = UISearchBar()
	private let tableView = UITableView(frame: .zero, style: .plain)

	private var searchText = "" {
		didSet { tableView.reloadData() }
	}

	private var filteredPairs: [(label: String, key: String)] {
		if searchText.isEmpty {
			return viewModel.pairs
		}
		return viewModel.pairs.filter {
			$0.label.lowercased().contains(searchText.lowercased())
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Crypto Live Prices"
		view.backgroundColor = .systemBackground

		setupUI()
		setupConstraints()

		viewModel.onUpdate = { [weak self] in
			self?.updateUI()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.connect()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		viewModel.disconnect()
	}

	private func setupUI() {
		priceLabel.font = .systemFont(ofSize: 28, weight: .bold)
		changeLabel.font = .systemFont(ofSize: 16)

		sectionLabel.text = "Stocks Monitoring"
		sectionLabel.font = .systemFont(ofSize: 17, weight: .semibold)

		searchBar.placeholder = "Search..."
		searchBar.searchBarStyle = .minimal
		searchBar.delegate = self

		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PairCell")
		tableView.separatorStyle = .none

		for subview in [priceLabel, changeLabel, chartView, sectionLabel, searchBar, tableView] {
			subview.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(subview)
		}
	}

	private func setupConstraints() {
		let margin: CGFloat = 16

		NSLayoutConstraint.activate(
			[
				// Price row
				priceLabel.topAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.topAnchor,
					constant: margin
				),
				priceLabel.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: margin
				),

				changeLabel.centerYAnchor.constraint(
					equalTo: priceLabel.centerYAnchor
				),
				changeLabel.leadingAnchor.constraint(
					equalTo: priceLabel.trailingAnchor,
					constant: 8
				),

				// Chart
				chartView.topAnchor.constraint(
					equalTo: priceLabel.bottomAnchor,
					constant: 12
				),
				chartView.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: margin
				),
				chartView.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: -margin
				),
				chartView.heightAnchor.constraint(
					equalToConstant: 300
				),

				// Section label
				sectionLabel.topAnchor.constraint(
					equalTo: chartView.bottomAnchor,
					constant: 20
				),
				sectionLabel.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: margin
				),

				// Search bar
				searchBar.topAnchor.constraint(
					equalTo: sectionLabel.bottomAnchor,
					constant: 4
				),
				searchBar.leadingAnchor.constraint(
					equalTo: view.leadingAnchor,
					constant: 8
				),
				searchBar.trailingAnchor.constraint(
					equalTo: view.trailingAnchor,
					constant: -8
				),

				// Table
				tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
				tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			]
		)
	}

	// MARK: - Update

	private func updateUI() {
		let pair = viewModel.selectedPair
		let price = viewModel.pairsData[pair]?.price ?? 0
		let change = viewModel.percentageChange(for: pair)
		let color: UIColor = change >= 0 ? .systemGreen : .systemRed

		priceLabel.text = String(format: "$%.2f", price)
		priceLabel.textColor = color

		let sign = change >= 0 ? "+" : ""
		changeLabel.text = String(format: "(%@%.2f%%)", sign, change)
		changeLabel.textColor = color

		chartView.data = viewModel.pairsData[pair]?.history ?? []

		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource & Delegate

extension CryptoRealTimeViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		filteredPairs.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
	UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PairCell", for:
													indexPath)
		let pair = filteredPairs[indexPath.row]
		let data = viewModel.pairsData[pair.key] ?? CryptoViewModel.PairData()
		let change = viewModel.percentageChange(for: pair.key)
		let isSelected = viewModel.selectedPair == pair.key

		var config = cell.defaultContentConfiguration()
		config.text = pair.label
		config.textProperties.font = .systemFont(ofSize: 16, weight: .bold)
		config.secondaryText = String(format: "$%.2f", data.price)
		config.secondaryTextProperties.font = .systemFont(ofSize: 12)
		cell.contentConfiguration = config

		let changeLabel = UILabel()
		changeLabel.font = .systemFont(ofSize: 11, weight: .bold)
		changeLabel.textColor = change >= 0 ? .systemGreen : .systemRed
		let sign = change >= 0 ? "+" : ""
		changeLabel.text = String(format: "%@%.2f%%", sign, change)
		cell.accessoryView = changeLabel
		changeLabel.sizeToFit()

		cell.backgroundColor = isSelected
		? UIColor.systemBlue.withAlphaComponent(0.2)
		: UIColor.systemGray.withAlphaComponent(0.1)
		cell.layer.cornerRadius = 8
		cell.clipsToBounds = true
		cell.selectionStyle = .none

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.selectedPair = filteredPairs[indexPath.row].key
	}
}

// MARK: - UISearchBarDelegate

extension CryptoRealTimeViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.searchText = searchText
	}
}

class LineChartView: UIView {
	var data: [Double] = [] {
		didSet { updateChart() }
	}

	private let lineLayer = CAShapeLayer()
	private let fillLayer = CAShapeLayer()
	private let gradientLayer = CAGradientLayer()
	private let highLabel = UILabel()
	private let lowLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	private func setup() {
		gradientLayer.colors = [
			UIColor.systemBlue.withAlphaComponent(0.4).cgColor,
			UIColor.systemBlue.withAlphaComponent(0.05).cgColor,
		]
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.mask = fillLayer
		layer.addSublayer(gradientLayer)

		lineLayer.strokeColor = UIColor.systemBlue.cgColor
		lineLayer.fillColor = UIColor.clear.cgColor
		lineLayer.lineWidth = 2
		layer.addSublayer(lineLayer)

		for label in [highLabel, lowLabel] {
			label.font = .systemFont(ofSize: 10)
			label.textColor = .secondaryLabel
			label.translatesAutoresizingMaskIntoConstraints = false
			addSubview(label)
		}

		NSLayoutConstraint.activate([
			highLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
			highLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
			lowLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
			lowLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
		])
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = bounds
		updateChart()
	}

	private func computePoints() -> [CGPoint] {
		guard data.count > 1 else { return [] }

		let width = bounds.width
		let height = bounds.height

		let minVal = data.min() ?? 0
		let maxVal = data.max() ?? 0
		let range = maxVal - minVal == 0 ? 1 : maxVal - minVal

		let stepX = width / CGFloat(data.count - 1)

		return data.enumerated().map { index, value in
			let xValue = CGFloat(index) * stepX
			let yRatio = (value - minVal) / range
			let yValue = height - CGFloat(yRatio) * height
			return CGPoint(x: xValue, y: yValue)
		}
	}

	private func updateChart() {
		let points = computePoints()

		let maxVal = data.max() ?? 0
		let minVal = data.min() ?? 0
		highLabel.text = String(format: "H: $%.2f", maxVal)
		lowLabel.text = String(format: "L: $%.2f", minVal)

		guard points.count > 1 else {
			lineLayer.path = nil
			fillLayer.path = nil
			return
		}

		let linePath = UIBezierPath()
		for (index, point) in points.enumerated() {
			if index == 0 {
				linePath.move(to: point)
			}
			else {
				linePath.addLine(to: point)
			}
		}
		lineLayer.path = linePath.cgPath

		let fillPath = UIBezierPath()
		fillPath.move(to: CGPoint(x: 0, y: bounds.height))
		for point in points {
			fillPath.addLine(to: point)
		}
		fillPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
		fillPath.close()
		fillLayer.path = fillPath.cgPath

		gradientLayer.frame = bounds
	}
}
