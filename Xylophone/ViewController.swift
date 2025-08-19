//
//  ViewController.swift
//  Xylophone
//
//  Created by Bárbara Letelier on 18-08-25.
//
import UIKit
import AVFoundation

final class ViewController: UIViewController {
    private var player: AVAudioPlayer?
    private let noteForTag: [Int: String] = [
        1: "Do",
        2: "Re",
        3: "Mi",
        4: "Fa",
        5: "Sol",
        6: "La",
        7: "Si",
        8: "2Do"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        debugListWavs()
    }

    @IBAction private func keyPressed(_ sender: UIButton) {
        guard let name = noteForTag[sender.tag] else {
            print("⚠️ Tag fuera de rango: \(sender.tag)")
            return
        }
        playSound(named: name)
        animatePress(sender)
    }

    // MARK: - Audio
    private func playSound(named soundName: String) {
        // Si importaste como "Create groups" (carpeta amarilla):
        let url1 = Bundle.main.url(forResource: soundName, withExtension: "wav")

        // Si por error quedó como folder reference (carpeta azul) llamada "Sounds":
        let url2 = Bundle.main.url(forResource: soundName, withExtension: "wav", subdirectory: "Sounds")

        guard let url = url1 ?? url2 else {
            print("❌ No se encontró \(soundName).wav en el bundle")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            print("▶️ Reproduciendo \(soundName)")
        } catch {
            print("❌ Error al reproducir \(soundName): \(error)")
        }
    }

    // MARK: - Visual Feedback
    private func animatePress(_ button: UIButton) {
        UIView.animate(withDuration: 0.08, animations: {
            button.alpha = 0.6
        }) { _ in
            UIView.animate(withDuration: 0.08) {
                button.alpha = 1.0
            }
        }
    }

    // MARK: - Debug
    private func debugListWavs() {
        let urls = (Bundle.main.urls(forResourcesWithExtension: "wav", subdirectory: nil) ?? [])
                 + (Bundle.main.urls(forResourcesWithExtension: "wav", subdirectory: "Sounds") ?? [])
        print("📦 WAVs en el bundle:", urls.map { $0.lastPathComponent })
    }
}
