import Foundation
import SwiftUI
import AVKit

struct VideoView: View {
	@State private var player: AVPlayer?
	@State private var playerObserver: NSObjectProtocol?
	@State private var isMuted: Bool = true
	var needMutedButton = false

	var body: some View {
		ZStack {
			if let player {
				VideoPlayer(player: player)
					.frame(maxWidth: .infinity)
					.clipped()

				if needMutedButton {
					VStack {
						HStack {
							Spacer()
							Button(action: {
								isMuted.toggle()
								player.isMuted = isMuted
							}) {
								Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
									.font(.title2)
									.foregroundColor(.white)
									.padding(8)
									.background(Color.black.opacity(0.2))
									.clipShape(Circle())
							}
							.padding()
						}
						Spacer()
					}
				}
			}
			else {
				Text("Video not found")
			}
		}
		.onAppear {
			guard let url = Bundle.main.url(
				forResource: "MeetComputer",
				withExtension: "mp4"
			)
			else {
				return
			}

			let avPlayer = AVPlayer(url: url)
			avPlayer.isMuted = true
			avPlayer.play()

			playerObserver = NotificationCenter.default.addObserver(
				forName: .AVPlayerItemDidPlayToEndTime,
				object: avPlayer.currentItem,
				queue: .main
			) { _ in
				avPlayer.seek(to: .zero)
				avPlayer.play()
			}

			player = avPlayer
		}
		.onDisappear {
			player?.pause()

			if let observer = playerObserver {
				NotificationCenter.default.removeObserver(observer)
				playerObserver = nil
			}
		}
	}
}
