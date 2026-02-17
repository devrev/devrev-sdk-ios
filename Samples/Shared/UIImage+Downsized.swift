import UIKit

extension UIImage {
	func downsized(toFit maxPixelSize: CGFloat) -> UIImage {
		let longerSide = max(size.width, size.height)
		guard longerSide > maxPixelSize
		else {
			return self
		}

		let scale = maxPixelSize / longerSide
		let targetSize = CGSize(
			width: round(size.width * scale),
			height: round(size.height * scale)
		)

		let format = UIGraphicsImageRendererFormat()
		format.scale = 1
		let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
		return renderer.image { _ in
			draw(in: CGRect(origin: .zero, size: targetSize))
		}
	}
}
