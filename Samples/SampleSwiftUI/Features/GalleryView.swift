import Foundation
import SwiftUI
import PhotosUI

struct GalleryView: View {
	private let title = "Gallery"
	@SwiftUI.State private var isGalleryPresented = false
	@SwiftUI.State private var selectedImages: [UIImage] = []

	private let columns = [
		GridItem(.flexible(), spacing: 8),
		GridItem(.flexible(), spacing: 8),
		GridItem(.flexible(), spacing: 8),
	]

	var body: some View {
		VStack(spacing: 0) {
			if selectedImages.isEmpty {
				EmptyStateView(
					systemImageName: "photo.on.rectangle.angled",
					title: "No Photos Selected",
					message: "Tap the button below to select photos from your gallery"
				)
			}
			else {
				ScrollView {
					LazyVGrid(columns: columns, spacing: 8) {
						ForEach(selectedImages.indices, id: \.self) { index in
							MaskedImageView(
								image: selectedImages[index],
								contentMode: .scaleAspectFill,
								cornerRadius: 8,
								shadowRadius: 4,
								shadowOpacity: 0.1,
								shadowOffset: CGSize(width: 0, height: 2),
								shadowColor: .black
							)
							.aspectRatio(1, contentMode: .fit)
							.transition(.scale.combined(with: .opacity))
						}
					}
					.padding(16)
					.animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedImages.count)
				}
			}

			VStack(spacing: 0) {
				Divider()

				HStack(spacing: 12) {
					Button(action: {
						isGalleryPresented = true
					}) {
						HStack(spacing: 8) {
							Image(systemName: "photo.on.rectangle")
								.font(.body.weight(.semibold))

							Text("Select Photos")
								.font(.body.weight(.semibold))
						}
						.frame(maxWidth: .infinity)
						.padding(.vertical, 16)
						.background(Color.accentColor)
						.foregroundColor(.white)
						.cornerRadius(14)
					}

					if !selectedImages.isEmpty {
						Button(action: {
							withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
								selectedImages.removeAll()
							}
						}) {
							HStack(spacing: 8) {
								Image(systemName: "trash")
									.font(.body.weight(.semibold))

								Text("Clear")
									.font(.body.weight(.semibold))
							}
							.padding(.vertical, 16)
							.padding(.horizontal, 20)
							.background(
								RoundedRectangle(cornerRadius: 14)
									.fill(Color.red.opacity(0.1))
							)
							.foregroundColor(.red)
						}
						.transition(.scale.combined(with: .opacity))
					}
				}
				.padding(.horizontal, 20)
				.padding(.vertical, 16)
				.background(Color(uiColor: .systemBackground))
			}
		}
		.navigationTitle(title)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				if !selectedImages.isEmpty {
					Text("\(selectedImages.count) \(selectedImages.count == 1 ? "photo" : "photos")")
						.font(.subheadline.weight(.medium))
						.foregroundColor(.secondary)
				}
			}
		}
		.sheet(isPresented: $isGalleryPresented) {
			MultiImagePicker(selectedImages: $selectedImages)
		}
	}
}

struct MultiImagePicker: UIViewControllerRepresentable {
	@Binding var selectedImages: [UIImage]
	@Environment(\.dismiss) var dismiss

	func makeUIViewController(context: Context) -> PHPickerViewController {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 0
		configuration.filter = .images

		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, PHPickerViewControllerDelegate {
		let parent: MultiImagePicker

		init(_ parent: MultiImagePicker) {
			self.parent = parent
		}

		func picker(
			_ picker: PHPickerViewController,
			didFinishPicking results: [PHPickerResult]
		) {
			parent.dismiss()

			let lock = NSLock()
			let group = DispatchGroup()
			var images: [UIImage] = []
			let maxThumbnailSize: CGFloat = 512

			for result in results {
				group.enter()
				result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
					if let image = object as? UIImage {
						let thumbnail = image.downsized(toFit: maxThumbnailSize)
						lock.lock()
						images.append(thumbnail)
						lock.unlock()
					}
					group.leave()
				}
			}

			group.notify(queue: .main) { [weak self] in
				withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
					self?.parent.selectedImages.append(contentsOf: images)
				}
			}
		}
	}
}
