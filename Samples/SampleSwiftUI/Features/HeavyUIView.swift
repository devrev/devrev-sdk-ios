import Foundation
import SwiftUI
import AVKit
import Lottie

struct HeavyUIView: View {
	@State var animationFinished: Bool = false

	var body: some View {
		ZStack {
			if animationFinished {
				VStack {
					HStack {
						Spacer()

						DevRevLogo()

						LottieFromName(name: "say_hi")
							.frame(width: 50, height: 50)
					}
					.padding(.horizontal, 10)
					.padding(.top, 60)

					ScrollView {
						VideoView(needMutedButton: true)
							.frame(height: 226)

						NestedScrollViews()
					}
				}
				.ignoresSafeArea(edges: .all)
			}
			else {
				VStack {
					LottieView(animation: .named("be_bold_animation"))
						.playbackMode(
							.playing(
								.toProgress(1, loopMode: .playOnce)
							)
						)
						.animationDidFinish { _ in
							animationFinished = true
						}

					Button("Next →") {
						animationFinished = true
					}
					.foregroundColor(.white)
				}
				.preferredColorScheme(.dark)
			}
		}
	}
}

struct NestedScrollViews: View {
	var body: some View {
		ScrollView {
			ScrollView() {
				VStack(spacing: 10) {
					VStack(alignment: .leading) {
						Text("Animations:")
							.font(Font.title.bold())
							.padding(.top)
							.padding(.leading)

						ScrollView(.horizontal) {
							HStack(spacing: 20) {
								ForEach(HeavyUIData.lottieAnimations.indices, id: \.self) { index in
									ScrollView(.vertical) {
										VStack(spacing: 5) {
											ForEach(HeavyUIData.lottieAnimations[index], id: \.self) { name in
												LottieFromName(name: name)
													.frame(
														width: 150,
														height: 150
													)
													.background(.gray.opacity(0.1))
													.cornerRadius(30)
													.clipped()
													.shadow(
														color: .black.opacity(0.3),
														radius: 6
													)
											}
										}
									}
								}
								LottieFromName(name: "lottie_empty")
								.frame(
									width: 300,
									height: 320
								)
								.background(.gray.opacity(0.1))
								.cornerRadius(30)
								.clipped()
								.shadow(
									color: .black.opacity(0.3),
									radius: 6
								)
							}
						}
						.frame(height: 320)
					}

					VStack(alignment: .leading) {
						Text("Images:")
							.font(Font.title.bold())
							.padding(.top)
							.padding(.leading)

						ScrollView(.horizontal) {
							HStack(spacing: 20) {
								ForEach(HeavyUIData.images, id: \.self) { name in
									LocalImage(name: name)
										.scaledToFill()
										.frame(width: 300, height: 300)
										.background(.gray.opacity(0.1))
										.cornerRadius(30)
										.clipped()
										.shadow(color: .black.opacity(0.3), radius: 6)
								}
							}
							.frame(height: 320)
						}
					}
				}
				.padding()
			}
		}
	}
}

struct LocalImage: View {
	var name: String
	var body: some View {
		if let url = Bundle.main.url(forResource: name, withExtension: nil),
		   let uiImage = UIImage(contentsOfFile: url.path) {
			Image(uiImage: uiImage)
				.resizable()
		}
	}
}

struct LottieFromName: View {
	var name: String
	var body: some View {
		LottieView(animation: .named(name))
			.playing(
				.fromProgress(
					0,
					toProgress: 1,
					loopMode: .loop
				)
			)
	}
}

struct DevRevLogo: View {
	var body: some View {
		HStack(spacing: 5) {
			Image("devrev_logo")
				.resizable()
				.scaledToFit()
				.frame(width: 25, height: 25)

			Text("DevRev")
				.font(Font.subheadline.bold())
		}
		.padding(.horizontal, 10)
		.padding(12)
		.background(Color.black.opacity(0.1))
		.cornerRadius(30)
	}
}
