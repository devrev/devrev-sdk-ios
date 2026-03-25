import Foundation
import SwiftUI

class CryptoViewModel: ObservableObject {
	struct PairData {
		var price: Double = 0
		var openPrice: Double = 0
		var history: [Double] = []
	}

	@Published var selectedPair = "btcusdt"

	@Published var pairsData: [String: PairData] = [
		"btcusdt": .init(),
		"ethusdt": .init(),
		"solusdt": .init(),
		"bnbusdt": .init(),
		"xrpusdt": .init(),
		"adausdt": .init(),
		"dogeusdt": .init(),
		"avaxusdt": .init(),
	]

	let pairs = [
		("BTC/USDT", "btcusdt"),
		("ETH/USDT", "ethusdt"),
		("SOL/USDT", "solusdt"),
		("BNB/USDT", "bnbusdt"),
		("XRP/USDT", "xrpusdt"),
		("ADA/USDT", "adausdt"),
		("DOGE/USDT", "dogeusdt"),
		("AVAX/USDT", "avaxusdt"),
	]

	private var webSocketTask: URLSessionWebSocketTask?

	func connect() {
		let streamURL = "wss://stream.binance.com:9443/stream?streams=" + "btcusdt@trade/ethusdt@trade/solusdt@trade/bnbusdt@trade/" + "xrpusdt@trade/adausdt@trade/dogeusdt@trade/avaxusdt@trade"

		guard let url = URL(string: streamURL)
		else {
			return
		}

		webSocketTask = URLSession.shared.webSocketTask(with: url)
		webSocketTask?.resume()

		print("WebSocket: Connected")

		receive()
	}

	func disconnect() {
		webSocketTask?.cancel(
			with: .goingAway,
			reason: nil
		)
		webSocketTask = nil
		print("WebSocket: Disconnected")
	}

	func percentageChange(for pair: String) -> Double {
		guard
			let data = pairsData[pair],
			data.openPrice != 0
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
			let json = try? JSONSerialization.jsonObject(
				with: data
			) as? [String: Any],

			let stream = json["stream"] as? String,
			let tradeData = json["data"] as? [String: Any],

			let priceString = tradeData["p"] as? String,
			let price = Double(priceString)
		else {
			return
		}

		let pair = stream.replacingOccurrences(
			of: "@trade",
			with: ""
		)

		DispatchQueue.main.async { [weak self] in
			guard let self
			else {
				return
			}

			if self.pairsData[pair]?.openPrice == 0 {
				self.pairsData[pair]?.openPrice = price
			}

			self.pairsData[pair]?.price = price
			self.pairsData[pair]?.history.append(price)

			if let size = self.pairsData[pair]?.history.count, size > 50 {
				self.pairsData[pair]?.history.removeFirst()
			}
		}
	}
}

struct CryptoRealtimeView: View {
	let title = "Crypto Live Prices"

	@StateObject private var viewModel = CryptoViewModel()
	@State private var searchText: String = ""

	var filteredPairs: [(String, String)] {
		if searchText.isEmpty {
			return viewModel.pairs
		}
		else {
			return viewModel.pairs.filter {
				$0.0.lowercased().contains(searchText.lowercased())
			}
		}
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				let current = viewModel.pairsData[viewModel.selectedPair]?.price ?? 0
				let change = viewModel.percentageChange(for: viewModel.selectedPair)

				HStack {
					Text("$\(current, specifier: "%.2f")")
						.font(.system(size: 28, weight: .bold))
						.foregroundColor(change >= 0 ? .green : .red)

					Text("(\(change >= 0 ? "+" : "")\(change, specifier: "%.2f")%)")
						.foregroundColor(change >= 0 ? .green : .red)
				}

				LineChartView(
					data: viewModel.pairsData[viewModel.selectedPair]?.history ?? []
				)
				.frame(height: 300)

				Spacer()
			}
			.padding()

			VStack(alignment: .leading) {
				Text("Stocks Monitoring")

				TextField("Search...", text: $searchText)
					.padding(7)
					.background(Color(.systemGray6))
					.cornerRadius(8)

				ForEach(filteredPairs, id: \.1) { pair in
					let data = viewModel.pairsData[pair.1] ?? CryptoViewModel.PairData()
					let change = viewModel.percentageChange(for: pair.1)

					Button(action: {
						viewModel.selectedPair = pair.1
					}) {
						HStack {
							VStack(alignment: .leading) {
								Text(pair.0).bold()

								Text("$\(data.price, specifier: "%.2f")")
									.font(.caption)
							}

							Spacer()

							Text("\(change >= 0 ? "+" : "")\(change, specifier: "%.2f")%\n")
								.font(.caption2.bold())
								.foregroundColor(change >= 0 ? .green : .red)
						}
						.padding()
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundStyle(Color(.label))
						.background(
							viewModel.selectedPair == pair.1
							? Color.blue.opacity(0.2)
							: Color.gray.opacity(0.1)
						)
						.cornerRadius(8)
					}
					.frame(maxWidth: .infinity)
				}
				Spacer()
			}
			.frame(maxWidth: .infinity)
			.padding()

			Spacer()
		}
		.navigationTitle(title)
		.onAppear {
			viewModel.connect()
		}
		.onDisappear {
			viewModel.disconnect()
		}
	}
}

// MARK: - Custom Line Chart

struct LineChartView: View {
	var data: [Double]

	var body: some View {
		GeometryReader { geometry in
			let maxVal = data.max() ?? 0
			let minVal = data.min() ?? 0

			ZStack {
				let points: [CGPoint] = {
					guard data.count > 1
					else {
						return []
					}

					let height = geometry.size.height
					let width = geometry.size.width

					let min = data.min() ?? 0
					let max = data.max() ?? 0
					let range = max - min == 0 ? 1 : max - min

					let stepX = width / CGFloat(data.count - 1)

					return data.indices.map { index in
						let yRatio = (data[index] - min) / range
						let xCoordinate: CGFloat = CGFloat(index) * stepX
						let yCoordinate = height - (CGFloat(yRatio) * height)
						return CGPoint(x: xCoordinate, y: yCoordinate)
					}
				}()

				if points.count > 1 {
					Path { path in
						for (index, point) in points.enumerated() {
							if index == 0 {
								path.move(to: point)
							}
							else {
								path.addLine(to: point)
							}
						}
					}
					.stroke(Color.blue, lineWidth: 2)

					Path { path in
						path.move(
							to: CGPoint(
								x: 0,
								y: geometry.size.height
							)
						)

						for point in points {
							path.addLine(to: point)
						}

						path.addLine(
							to: CGPoint(
								x: geometry.size.width,
								y: geometry.size.height
							)
						)

						path.closeSubpath()
					}
					.fill(
						LinearGradient(
							gradient: Gradient(colors: [
								Color.blue.opacity(0.4),
								Color.blue.opacity(0.05),
							]),
							startPoint: .top,
							endPoint: .bottom
						)
					)
				}
			}
			.overlay(alignment: .topLeading) {
				Text("H: $\(maxVal, specifier: "%.2f")")
					.font(.caption2)
					.foregroundColor(.secondary)
					.padding(4)
			}
			.overlay(alignment: .bottomLeading) {
				Text("L: $\(minVal, specifier: "%.2f")")
					.font(.caption2)
					.foregroundColor(.secondary)
					.padding(4)
			}
		}
	}
}
