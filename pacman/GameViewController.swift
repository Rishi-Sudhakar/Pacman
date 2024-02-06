import Cocoa
import SpriteKit

class GameViewController: NSViewController {

    var gameScene: GameScene!
    var gameView: SKView!
    var pauseButton: NSButton!
    var restartButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameView()
        setupGameScene()
        setupUI()
    }

    func setupGameView() {
        gameView = SKView(frame: view.frame)
        view.addSubview(gameView)
        gameView.showsFPS = true // Optional: Show FPS counter
        gameView.showsNodeCount = true // Optional: Show node count
    }

    func setupGameScene() {
        gameScene = GameScene(size: gameView.frame.size)
        gameScene.scaleMode = .aspectFill
        gameView.presentScene(gameScene)
        gameView.ignoresSiblingOrder = true
        gameView.allowsTransparency = true
    }

    func setupUI() {
        pauseButton = NSButton(title: "Pause", target: self, action: #selector(pauseGame))
        pauseButton.frame = NSRect(x: 20, y: 20, width: 100, height: 30)
        view.addSubview(pauseButton)

        restartButton = NSButton(title: "Restart", target: self, action: #selector(restartGame))
        restartButton.frame = NSRect(x: 20, y: 60, width: 100, height: 30)
        view.addSubview(restartButton)
    }

    @objc func pauseGame() {
        gameScene.isPaused = !gameScene.isPaused
        pauseButton.title = gameScene.isPaused ? "Resume" : "Pause"
    }

    @objc func restartGame() {
        gameScene.removeAllChildren()
        gameScene.removeAllActions()
        setupGameScene()
    }

    override func keyDown(with event: NSEvent) {
        gameScene.handleInput(event, isKeyDown: true) // Pass isKeyDown parameter
    }

    override func keyUp(with event: NSEvent) {
        gameScene.handleInput(event, isKeyDown: false) // Pass isKeyDown parameter
    }
}

