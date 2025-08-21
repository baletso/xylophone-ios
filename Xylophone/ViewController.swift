import UIKit
import AVFoundation

final class ViewController: UIViewController {

    @IBOutlet var keyButtons: [UIButton]!

    private var player: AVAudioPlayer?
    private let pinTag = 4242

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("❌ AVAudioSession error:", error)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        keyButtons.forEach { btn in
            if btn.subviews.first(where: { $0.tag == pinTag }) == nil {
                addPins(to: btn)
            }
        }
    }

    @IBAction func keyPressed(_ sender: UIButton) {
        animateTap(on: sender)

        let soundName = sender.accessibilityIdentifier?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let fallback = sender.titleLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let name = (soundName?.isEmpty == false ? soundName : fallback),
              !name.isEmpty else {
            print("❌ No hay nombre de sonido para el botón.")
            return
        }

        playSound(named: name)
    }

    private func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("❌ No se encontró \(soundName).wav en el bundle")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            print("✅ Reproduciendo \(soundName).wav")
        } catch {
            print("❌ Error AVAudioPlayer:", error)
        }
    }

    private func animateTap(on button: UIButton) {
        UIView.animate(withDuration: 0.07, animations: {
            button.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { _ in
            UIView.animate(withDuration: 0.12) {
                button.transform = .identity
            }
        }
    }

    private func addPins(to button: UIButton) {

        let pinSize: CGFloat = 18
        let inset: CGFloat = 16

        func makePin() -> UIView {
            let v = UIView()
            v.tag = pinTag
            v.isUserInteractionEnabled = false
            v.backgroundColor = .white
            v.translatesAutoresizingMaskIntoConstraints = false
            v.layer.cornerRadius = pinSize / 2
            v.clipsToBounds = true
            return v
        }

        let leftPin = makePin()
        let rightPin = makePin()

        button.addSubview(leftPin)
        button.addSubview(rightPin)

        NSLayoutConstraint.activate([
            // Izquierdo
            leftPin.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            leftPin.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: inset),
            leftPin.widthAnchor.constraint(equalToConstant: pinSize),
            leftPin.heightAnchor.constraint(equalToConstant: pinSize),

            // Derecho
            rightPin.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            rightPin.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -inset),
            rightPin.widthAnchor.constraint(equalToConstant: pinSize),
            rightPin.heightAnchor.constraint(equalToConstant: pinSize),
        ])
        button.layoutIfNeeded()
    }
}
