import Foundation
import SwiftUI

struct CameraView: View {
	private let title = "Camera"
	@SwiftUI.State private var isCameraPresented = false
	@SwiftUI.State private var selectedImage: UIImage?
    @SwiftUI.State private var isCameraUnavailableAlert = false

	var body: some View {
		VStack(spacing: 0) {
			if let image = selectedImage {
				ScrollView {
					VStack(spacing: 16) {
						MaskedImageView(
							image: image,
							contentMode: .scaleAspectFit,
							cornerRadius: 16,
							shadowRadius: 10,
							shadowOpacity: 0.1,
							shadowOffset: CGSize(width: 0, height: 5),
							shadowColor: .black
						)
						.padding()
						.transition(
							.scale.combined(with: .opacity)
						)

						Button(
							action: {
								withAnimation(.spring(
									response: 0.3,
									dampingFraction: 0.7
								)) {
									selectedImage = nil
								}
							}
						) {
							Label(
								"Clear Photo",
								systemImage: "trash"
							)
								.font(.body.weight(.medium))
								.foregroundColor(.red)
								.padding(.horizontal, 24)
								.padding(.vertical, 12)
								.background(
									RoundedRectangle(cornerRadius: 12)
										.fill(Color.red.opacity(0.1))
								)
						}
						.padding(.bottom, 16)
					}
				}
			}
			else {
				EmptyStateView(
					systemImageName: "camera.fill",
					title: "No Photo Captured",
					message: "Tap the button below to capture a photo"
				)
			}

			VStack(spacing: 0) {
				Divider()

				Button(action: {
					if UIImagePickerController.isSourceTypeAvailable(.camera) {
						isCameraPresented = true
					}
					else {
						isCameraUnavailableAlert = true
					}
				}) {
					HStack(spacing: 12) {
						Image(systemName: "camera")
							.font(.body.weight(.semibold))

						Text("Open Camera")
							.font(.body.weight(.semibold))
					}
					.frame(maxWidth: .infinity)
					.padding(.vertical, 16)
					.background(Color.accentColor)
					.foregroundColor(.white)
					.cornerRadius(14)
				}
				.padding(.horizontal, 20)
				.padding(.vertical, 16)
				.background(Color(uiColor: .systemBackground))
			}
		}
		.navigationTitle(title)
		.navigationBarTitleDisplayMode(.inline)
        .alert("Camera Unavailable", isPresented: $isCameraUnavailableAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("This device does not have a camera.")
        }
		.sheet(isPresented: $isCameraPresented) {
			ImagePickerView(sourceType: .camera, selectedImage: $selectedImage)
		}
	}
}

struct ImagePickerView: UIViewControllerRepresentable {
	let sourceType: UIImagePickerController.SourceType
	@Binding var selectedImage: UIImage?
	@Environment(\.dismiss) var dismiss

	func makeUIViewController(context: Context) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.sourceType = sourceType
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		let parent: ImagePickerView

		init(_ parent: ImagePickerView) {
			self.parent = parent
		}

		func imagePickerController(
			_ picker: UIImagePickerController,
			didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
		) {
			if let image = info[.originalImage] as? UIImage {
				let maxPixelWidth = UIScreen.main.bounds.width * UIScreen.main.scale
				let resizedImage = image.downsized(toFit: maxPixelWidth)
				withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
					parent.selectedImage = resizedImage
				}
			}
			parent.dismiss()
		}

		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			parent.dismiss()
		}
	}
}
