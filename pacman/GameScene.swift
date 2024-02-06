import SpriteKit

class GameScene: SKScene {
    let gridSize: CGFloat = 20
    let pacmanSpeed: CGFloat = 1.25 // Adjust player speed
    let enemySpeed: CGFloat = 0.6 // Adjust enemy speed
    let railWidth: CGFloat = 5.0 // Adjust rail width
    let railColor = SKColor.blue // Adjust rail color
    
    var pacmanNode: SKSpriteNode!
    var foodNodes = [SKSpriteNode]()
    var enemyNodes = [SKSpriteNode]()
    var rails = [SKSpriteNode]()
    var scoreLabel: SKLabelNode!
    var score = 0
    
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    
    override func didMove(to view: SKView) {
        setupPacman()
        setupFood()
        setupEnemies()
        setupRails()
        setupScoreLabel()
        
        // Allow the scene to resize with the view
        self.scaleMode = .resizeFill
    }
    
    func setupPacman() {
        pacmanNode = SKSpriteNode(color: .yellow, size: CGSize(width: gridSize * 0.8, height: gridSize * 0.8))
        pacmanNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(pacmanNode)
    }
    
    func setupFood() {
        for row in 1..<Int(size.height/gridSize) - 1 {
            for col in 1..<Int(size.width/gridSize) - 1 {
                if Int.random(in: 0..<10) < 2 { // Adjust probability for food spawn
                    let foodNode = SKSpriteNode(color: .yellow, size: CGSize(width: gridSize * 0.5, height: gridSize * 0.5))
                    foodNode.position = CGPoint(x: CGFloat(col) * gridSize + gridSize / 2, y: CGFloat(row) * gridSize + gridSize / 2)
                    addChild(foodNode)
                    foodNodes.append(foodNode)
                }
            }
        }
    }
    
    func setupEnemies() {
        for _ in 0..<5 { // Adjust number of enemies
            let enemyNode = SKSpriteNode(color: .red, size: CGSize(width: gridSize * 0.8, height: gridSize * 0.8))
            let randomRow = Int.random(in: 1..<Int(size.height/gridSize) - 1)
            let randomCol = Int.random(in: 1..<Int(size.width/gridSize) - 1)
            enemyNode.position = CGPoint(x: CGFloat(randomCol) * gridSize + gridSize / 2, y: CGFloat(randomRow) * gridSize + gridSize / 2)
            addChild(enemyNode)
            enemyNodes.append(enemyNode)
        }
    }
    
    func setupRails() {
        // Add random rails
        for _ in 0..<12 {
            let randomRow = Int.random(in: 1..<Int(size.height/gridSize) - 1)
            let randomCol = Int.random(in: 1..<Int(size.width/gridSize) - 1)
            let railNode = SKSpriteNode(color: railColor, size: CGSize(width: gridSize, height: gridSize))
            railNode.position = CGPoint(x: CGFloat(randomCol) * gridSize + gridSize / 2, y: CGFloat(randomRow) * gridSize + gridSize / 2)
            addChild(railNode)
            rails.append(railNode)
        }
    }
    
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 100, y: size.height - 50)
        scoreLabel.fontName = "Arial"
        scoreLabel.fontSize = 20
        addChild(scoreLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        movePacman()
        moveEnemies()
        checkCollisions()
    }
    
    func movePacman() {
        let newX = pacmanNode.position.x + dx
        let newY = pacmanNode.position.y + dy
        
        if isValidMove(newX: newX, newY: newY) {
            pacmanNode.position.x = newX
            pacmanNode.position.y = newY
        }
    }
    
    func moveEnemies() {
        for enemyNode in enemyNodes {
            let dx = pacmanNode.position.x - enemyNode.position.x
            let dy = pacmanNode.position.y - enemyNode.position.y
            let angle = atan2(dy, dx)
            let velocityX = cos(angle) * enemySpeed
            let velocityY = sin(angle) * enemySpeed
            let nextX = enemyNode.position.x + velocityX
            let nextY = enemyNode.position.y + velocityY
            
            // Check if the next position is not inside a rail
            if isValidMove(newX: nextX, newY: nextY) {
                enemyNode.position.x = nextX
                enemyNode.position.y = nextY
            }
        }
    }
    
    func checkCollisions() {
        for foodNode in foodNodes {
            if pacmanNode.frame.intersects(foodNode.frame) {
                foodNode.removeFromParent()
                if let index = foodNodes.firstIndex(of: foodNode) {
                    foodNodes.remove(at: index)
                    score += 10 // Increment score
                    updateScoreLabel()
                }
            }
        }
        
        for enemyNode in enemyNodes {
            if pacmanNode.frame.intersects(enemyNode.frame) {
                gameOver()
            }
        }
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func gameOver() {
        print("Game Over!")
        // Implement game over logic here
    }
    
    override func keyDown(with event: NSEvent) {
        handleInput(event, isKeyDown: true)
    }
    
    override func keyUp(with event: NSEvent) {
        handleInput(event, isKeyDown: false)
    }
    
    func handleInput(_ event: NSEvent, isKeyDown: Bool) {
        guard let key = event.charactersIgnoringModifiers?.first else { return }
        
        switch key {
        case "w":
            dy = isKeyDown ? pacmanSpeed : 0
        case "s":
            dy = isKeyDown ? -pacmanSpeed : 0
        case "a":
            dx = isKeyDown ? -pacmanSpeed : 0
        case "d":
            dx = isKeyDown ? pacmanSpeed : 0
        default:
            break
        }
    }
    
    func isValidMove(newX: CGFloat, newY: CGFloat) -> Bool {
        for railNode in rails {
            if railNode.frame.contains(CGPoint(x: newX, y: newY)) {
                return false
            }
        }
        return true
    }
}

