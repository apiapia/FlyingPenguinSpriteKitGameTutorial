# FlyingPenguinSpriteKitGameTutorial
SpriteKit Game Tutorial by iFIERO.com


动画演示 (https://upload-images.jianshu.io/upload_images/3896436-7bc99f99cf931ac8.gif)
<img src="https://upload-images.jianshu.io/upload_images/3896436-7bc99f99cf931ac8.gif">


开始场景
<img src="https://upload-images.jianshu.io/upload_images/3896436-456f003f7378d935.png?imageMogr2/auto-orient/">


游戏过程
<img src="https://upload-images.jianshu.io/upload_images/3896436-c4f787c38d6b8233.png?imageMogr2/auto-orient/">


结束场景
<img src="https://upload-images.jianshu.io/upload_images/3896436-db986d365000c713.png?imageMogr2/auto-orient/">

/*

*** 游戏元素使用条款及注意事项 ***
游戏中的所有元素全部由iFIERO所原创(除注明引用之外)，包括人物、音乐、场景等，
创作的初衷就是让更多的游戏爱好者可以在开发游戏中获得自豪感 -- 让手机游戏开发变得简单。
秉着开源分享的原则,iFIERO发布的游戏都尽可能的易懂实用，并开放所有源码，
任何使用者都可以使用游戏中的代码块，也可以进行拷贝、修改、更新、升级，无须再经过iFIERO的同意。
但这并不表示可以任意复制、拆分其中的游戏元素:
用于[商业目的]而不注明出处，
用于[任何教学]而不注明出处,
用于[游戏上架]而不注明出处；
另外,iFIERO有商用授权游戏元素，获得iFIERO官方授权后，即无任何限制！
请尊重帮助过你的iFIERO的知识产权，非常感谢！
Created by VANGO杨 && ANDREW陈
Copyright © 2018 iFiero. All rights reserved.
www.iFIERO.com
iFIERO -- 让手机游戏开发变得简单
FlyingPenguin 飞吧企鹅 在此游戏中您将获得如下技能：
1、LaunchScreen 学习如何设置游戏启动画面;
2、Endless Background 无限循环背景;
3、Scene Edit 直接使用可见即所得操作,注意scebe场景的中心点是anchor0.5*0.5;
4、UserDefaults 保存游戏分数、最高分;
5、Random+moveBy 利用可复用的随机函数生成Obstacle障碍物;
6、Juice:Particle 粒子特效;
7、ScreenShot+Share 截屏+分享链接GameScene传值给ViewController;
8、Protocol代理 代理传值保存图片时须设置程序读取手机图片的权限info.plist中的Privicy;
9、StateMachine GameplayKit 运用之场景; (**** 中级技能)
10、Entity+Component Entity对象+Component组件的运用; (**** 中级技能)
11、Velocity+Rotate Velocity向量(速度+方向)及角度计算;
12、Wobbling 利用moveBy+reverse制作出企鹅上下舞动的效果;
12B、Juice:ScreenShake Juice特效：学习企鹅撞到障碍物后，整个屏幕发生抖动;(**** 高级技能)
*/

import SpriteKit
import GameplayKit

// 为何设置代理：ViewController须弹出分享View
protocol GameSceneDelegate:class {
    func screenShot() -> UIImage  // 截屏代理
    func shareUrl(_ textString:String,url:URL,image:UIImage) // 分享链接代理、传递图片、说明文字
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    weak var gameSceneDelegate:GameSceneDelegate?
    var moveAllowed = false // 场景是否可以移动
    
    //MARK: - StateMachine 场景中各个舞台State
    lazy var stateMachine:GKStateMachine = GKStateMachine(states: [
        WaitingForTapState(scene: self),
        PlayingState(scene: self),
        FallingState(scene:self),
        GameOverState(scene: self)])
    
    let appStoreLink = "http://www.iFiero.com" //游戏上线后换成app store上的游戏下载地址;
    var score = 0           // 游戏分数
    var dt:TimeInterval = 0 // 每一frame的时间差
    var lastUpdateTimeInterval:TimeInterval = 0 // 最后更新的时间
    
    /* UI元素中的场景移动速度 注意：用真机运行FPS 60s,模拟器simular的FPS 10s */
    let cloudDistance:CGFloat     = 5   // 白云
    let treeDistance:CGFloat      = 8   // 树
    let mounationDistance:CGFloat = 2   // 山
    let groundSpeed: CGFloat      = 9   // 地板的移动速度;
    let obstacleSpeed:CGFloat     = 450 // 值越大，移动速度越快
    let obstacleDelayTime:CGFloat = 2.2 // 每次生成障碍物的时间间隔 2.0s
    let firstSpawnDelay: TimeInterval = 0.8  // 首次生成 Obstacle
    var everySpawnDelay: TimeInterval = 4.0 // 每个Obstacle生成的时间间隔 值越大 游戏难度越小;
    let numberOfScenes:CGFloat = 2 // 有二个场景
    
    /*物理重力*/
    let impluse:CGFloat = 600         // 每次拍打的向上动力
    let gravity:CGFloat = -1800       // 向下的重力
    var initVelocity = CGPoint.zero   // 速度+方向
    var velocityModifier:CGFloat = 1000.0 //数值转化为弧度;
    var angularVelocity:CGFloat = 0.0 // 角度;
    var lastTouchY:CGFloat = 0.0       // 最新点击的Y轴位置;
    let minDegree:CGFloat = -25 // 水平线 ：向下的角度(左到右)
    let maxDegree:CGFloat = 25  // 向上的角度
    
    /*场景中的所有SpriteNode*/
    private var worldNode:SKSpriteNode!
    private var groundNode:SKSpriteNode!
    
    private var playerNode:SKSpriteNode!
    private var crownNode:SKSpriteNode!
    // let obstacle = ObstacleEntity(imageName: "obstacle") // 障碍物;
    
    /*
     * 若有取得场景中的白云节点，需命名场景中的每一个节点的名称 Attritubes inspector面板命名;
     */
    private var cloud1_1:SKSpriteNode!  // 白云1
    private var cloud1_2:SKSpriteNode!  //
    private var cloud1_3:SKSpriteNode!  //
    private var cloud1_4:SKSpriteNode!  //
    private var cloud2_1:SKSpriteNode!  // 白云2
    private var cloud2_2:SKSpriteNode!  //
    private var cloud2_3:SKSpriteNode!  //
    private var cloud2_4:SKSpriteNode!  //
    
    
    
    var playableHeight:CGFloat = 0  // 企鹅的可飞行区域
    var playableStart:CGFloat  = 0  // 地板的位置
    var playerTextureAtlas = SKTextureAtlas()
    var playerTextures     = [SKTexture]()
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector.zero   // 物理世界的重力
        physicsWorld.contactDelegate = self    // 碰撞代理;
        
        setupBgSound()    // ** 加入背景音乐
        worldNode = childNode(withName: "worldNode") as! SKSpriteNode
        //MARK:- 分享按钮 注意观察GameScene.sks的层级 shareNode是属于worldNode的下一级
        setupBackground() /// 场景
        setupSceneUI()    /// 取得可视化Scene编辑下的UI元素
        setupPlayer()     /// 加入玩家企鹅
        startWobble()     /// 上下浮动 + 拍打翅膀
        
        stateMachine.enter(WaitingForTapState.self) /// 进入场景后 直接进入WaitingForTap State
    }
    
    //MARK:- 场景总节点
    func setupBackground(){
        // 注意：用可视化拖拉sprite到scene时，有二个节点，需要用enumerateChildNodes找到所有的ground;
        groundNode = worldNode.childNode(withName: "ground") as! SKSpriteNode
        
        worldNode.enumerateChildNodes(withName: "ground") { (node, error) in
            let groundNode = node as! SKSpriteNode
            let topLeft  = CGPoint(x: 0, y: groundNode.size.height)
            let topRight = CGPoint(x: self.size.width, y: groundNode.size.height)
            groundNode.physicsBody = SKPhysicsBody(edgeFrom: topLeft, to: topRight)
            groundNode.physicsBody?.affectedByGravity  = true   /// 不受重力影响
            groundNode.physicsBody?.isDynamic = false
            groundNode.physicsBody?.categoryBitMask    = PhysicsCategory.Ground
            groundNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Crown
            groundNode.physicsBody?.collisionBitMask   = PhysicsCategory.Crown
        }
        
        // playableStart  = groundNode.size.height      // 从地板高度height的开始点;
        // playableHeight = size.height - playableStart // 企鹅的可飞行区域;
    }
    //MARK: - 取得可视化Scene编辑下的UI元素
    func setupSceneUI(){
        // 白云
        // 场景1的白云 cloud1_1.position.x + size.width = 场景2的白云位置 cloud2_1.position.x (Y轴不变)
        cloud1_1 = worldNode.childNode(withName: "cloud1_1")  as! SKSpriteNode
        cloud1_2 = worldNode.childNode(withName: "cloud1_2")  as! SKSpriteNode
        cloud1_3 = worldNode.childNode(withName: "cloud1_3")  as! SKSpriteNode
        cloud1_4 = worldNode.childNode(withName: "cloud1_4")  as! SKSpriteNode
        
        cloud2_1 = worldNode.childNode(withName: "cloud2_1")  as! SKSpriteNode
        cloud2_2 = worldNode.childNode(withName: "cloud2_2")  as! SKSpriteNode
        cloud2_3 = worldNode.childNode(withName: "cloud2_3")  as! SKSpriteNode
        cloud2_4 = worldNode.childNode(withName: "cloud2_4")  as! SKSpriteNode
    }
    
    //MARK: - 移动地板(注：另一方法为移动Camera)
    func moveEndlessGround(dt:TimeInterval){
        // 检测场景中名称为 tree的所有节点;
        worldNode.enumerateChildNodes(withName: "ground") { (node, error) in
            let groundNode = node as! SKSpriteNode
            let moveAmount = CGPoint(x: -self.groundSpeed,y: 0)
            groundNode.position.x += moveAmount.x
            if groundNode.position.x < -self.size.width {
                groundNode.position.x += SCENE_WIDTH * self.numberOfScenes
            }
        }
    }
    //MARK: - 移动白云(注意：此处白云没有一直生成并销毁)
    func moveEndlessCloud(dt:TimeInterval){
        //白云
        cloud1_1.position.x -= cloudDistance
        cloud1_2.position.x -= cloudDistance*1.2 //变化速度
        cloud1_3.position.x -= cloudDistance
        cloud1_4.position.x -= cloudDistance*0.7
        
        cloud2_1.position.x -= cloudDistance
        cloud2_2.position.x -= cloudDistance*1.2
        cloud2_3.position.x -= cloudDistance
        cloud2_4.position.x -= cloudDistance*0.7
        // 第一朵
        if cloud1_1.position.x < -SCENE_WIDTH {
            cloud1_1.position.x +=  SCENE_WIDTH * numberOfScenes
        }
        if cloud2_1.position.x < -size.width {
            cloud2_1.position.x +=  SCENE_WIDTH * numberOfScenes
        }
        // 第二朵
        if cloud1_2.position.x < -size.width {
            cloud1_2.position.x +=  SCENE_WIDTH * numberOfScenes
        }
        if cloud2_2.position.x < -size.width {
            cloud2_2.position.x +=  SCENE_WIDTH * numberOfScenes
        }
        // 第三朵
        if cloud1_3.position.x < -size.width {
            cloud1_3.position.x +=  SCENE_WIDTH * numberOfScenes
        }
        if cloud2_3.position.x < -size.width {
            cloud2_3.position.x +=  SCENE_WIDTH * numberOfScenes
        }
        // 第四朵
        if cloud1_4.position.x < -size.width {
            cloud1_4.position.x +=  SCENE_WIDTH * numberOfScenes
        }
        if cloud2_4.position.x < -size.width {
            cloud2_4.position.x +=  SCENE_WIDTH * numberOfScenes
        }
    }
    //MARK:- 移动TREE
    func moveEndlessTree(dt:TimeInterval){
        // 检测场景中名称为 tree的所有节点;
        worldNode.enumerateChildNodes(withName: "tree") { (node, error) in
            let treeNode = node as! SKSpriteNode
            let moveAmount = CGPoint(x: -self.treeDistance,y: 0)
            treeNode.position.x += moveAmount.x
            if treeNode.position.x < -self.size.width {
                treeNode.position.x += SCENE_WIDTH * self.numberOfScenes
            }
        }
    }
    //MARK:- 移动山
    func moveEndlessMountain(dt:TimeInterval){
        // 检测场景中名称为 mounation的所有节点;
        worldNode.enumerateChildNodes(withName: "mountain") { (node, error) in
            let mounNode = node as! SKSpriteNode
            let moveAmount = CGPoint(x: -self.mounationDistance,y: 0)
            mounNode.position.x += moveAmount.x
            if mounNode.position.x < -self.size.width {
                mounNode.position.x +=  SCENE_WIDTH * self.numberOfScenes
            }
        }
    }
    //MARK:- 加入玩家Penguin
    func setupPlayer(){
        playerNode = worldNode.childNode(withName: "player") as! SKSpriteNode // 企鹅属于worldNode的子层级;
        playerTextureAtlas = SKTextureAtlas(named: "penguin")
        for i in 1...playerTextureAtlas.textureNames.count {
            let imageName = "penguin0\(i)"
            playerTextures.append(SKTexture(imageNamed: imageName))
        }
        
        /* 建立物理体
         * playerNode.zPosition = 6 直接在GameScene.sks设置 > 位于地板上层
         * 核心知识:
         * 1.原有sprite拖到scene后，只要大小有缩小(变化) scale=0.7,则texture也要相应缩小0.7;
         * 2.sprite的anchorPoint有变化,须重新设置物理体的center,中心点位于物理体的正中心,即x=playerNode.size.width/2;
         * 3.设置后物理体的碰撞就非常精确;
         */
        let width  = playerNode.size.width * 0.5 // 缩小物理体
        let height = playerNode.size.height * 0.7
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height),center:CGPoint(x: playerNode.size.width/2/2, y:0)) // X轴:playerNode.size.width/2,Y轴:0
        // 监测碰撞
        //  print("playerNode.size:\(playerNode.size),向右移动:\(playerNode.size.width/2/2),碰撞width:\(width)")
        playerNode.physicsBody?.affectedByGravity  = false 
        playerNode.physicsBody?.categoryBitMask    = PhysicsCategory.Player  // 1.标识
        playerNode.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Obstacle  // 2.会和谁相撞发出通知
        playerNode.physicsBody?.collisionBitMask   = PhysicsCategory.None     // 3.会相撞(相互作用)吗
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    //MARK:- 随机大量产生金币 Timer
    func spawningCoins(){
        Timer.scheduledTimer(timeInterval: TimeInterval(3.0), target: self, selector: #selector(spawnSingleCoin), userInfo: nil, repeats: true)
    }
    //MARK:- 加入金币 Timer 函数前加@objc
    @objc func spawnSingleCoin(){
        if moveAllowed {
            // 1.生成随机位置的coin
            let coinNode = CoinSprite.sharedInstance()
            let minY = groundNode.size.height  // 开始处
            let maxY = size.height
            let randomY = CGFloat.random(minY, max: maxY)
            
            let minX = SCENE_WIDTH * 0.1
            let maxX = SCENE_WIDTH * 1.2
            let randomX = CGFloat.random(minX, max: maxX)
            
            coinNode.position = CGPoint(x: size.width + randomX, y: randomY)
            worldNode.addChild(coinNode)
            // 2.移动coin 并销除;
            // MARK: -2.移动障碍物;
            let moveByX = SCENE_WIDTH * 2 + coinNode.size.width * 2
            let moveDuration = moveByX / obstacleSpeed
            
            let move = SKAction.moveBy(x: -moveByX, y: 0, duration: TimeInterval(moveDuration))
            let sequence = SKAction.sequence([move,SKAction.removeFromParent()])
            coinNode.run(sequence)
        }
    }
    
    // MARK:- 生成单个Obstcale障碍物并移动
    // Anchor(0.5,0)** Y轴位置如果不明白，可以拖一个ColorSprite到场景中,可以直观的进行Y轴的定位;
    // 高度为 1536 - Player 200 / 2 为总体的尺寸
    func spawnSingleObstacle(){
        // MARK: -1.生成一个障碍物对象
        //X轴的位置 位于屏幕的右侧+obstacle.width 产生后再移动 屏幕的左侧 并消除对象
        let bottomObstacle = createObstacle()
        let topObstacle = createObstacle()
        let wallObstacle = SKNode()
        
        let randomY =  CGFloat.random(0, max: groundNode.size.height)
        var startX = size.width
        //worldNode -> wallObstacle ->
        startX = startX + bottomObstacle.size.width // 位置位于屏幕的最右侧;
        bottomObstacle.position = CGPoint(x: startX, y: 0)
        wallObstacle.addChild(bottomObstacle)
        
        topObstacle.zRotation = CGFloat(180).degreesToRadians()  // 旋转180°  CGFloat(Double.pi)
        topObstacle.position.x = bottomObstacle.position.x
        topObstacle.position.y = self.size.height
        wallObstacle.addChild(topObstacle)
        
        wallObstacle.position.y += randomY // 返回在Y轴随机位置
        wallObstacle.name = "wallObstacle"
        worldNode.addChild(wallObstacle)
        
        // MARK: -2.移动障碍物;
        let moveByX = size.width + bottomObstacle.size.width * 2
        let moveDuration = moveByX / obstacleSpeed
        
        let moveAction = SKAction.moveBy(x: -moveByX, y: 0, duration: TimeInterval(moveDuration))
        let sequence   = SKAction.sequence([moveAction,SKAction.removeFromParent()])
        wallObstacle.run(sequence)
        
    }
    
    //MARK:-- 不断生成Obstcale 只执行一次didMove;(挑战，delay时间间隔不同 产生的obstacle的间距不同)
    // 区别于生成coins的Timer方法
    // PlayingState 调用
    func spawningObstcale(_ dt:TimeInterval){
        let spawn = SKAction.run(spawnSingleObstacle)  // 生成一个障碍物
        let delay = SKAction.wait(forDuration: TimeInterval(obstacleDelayTime))     // obstacleDelayTime间距
        
        let spawnSequence = SKAction.sequence([spawn,delay])
        let foreverSpawn = SKAction.repeatForever(spawnSequence)
        
        let firstDelay = SKAction.wait(forDuration: firstSpawnDelay)
        let overallSequence = SKAction.sequence([firstDelay, foreverSpawn])
        run(overallSequence, withKey: "spawn")
    }
    //MARK:-分享链接
    func shareScore(){
        let urlString = appStoreLink
        let url = URL(string: urlString)
        let screenShot = gameSceneDelegate?.screenShot() // 取得截图
        let textString = "嘿,我在Flying Peguin飞吧企鹅中取得了\(self.score)分数,你也快来挑战吧!"
        // 调用代理，把shareUrl传统到ViewController；
        gameSceneDelegate?.shareUrl(textString, url: url!, image: screenShot!)
    }
    
    //MARK:- option+command+<- 折叠
    func setupBgSound(){
        let bgSound = SKAudioNode(fileNamed: "jazzmusic.mp3")
        bgSound.autoplayLooped = true
        addChild(bgSound)
    }
    //MARK:- 开始拍打翅膀
    func startAnimation(){
        let playerAnimation = SKAction.animate(with: playerTextures, timePerFrame: 0.07)
        let repeatAction    = SKAction.repeatForever(playerAnimation)
        playerNode.run(repeatAction, withKey: "Flap")
    }
    
    func stopAnimation(_ name:String){
        playerNode.removeAction(forKey:name) // Player
    }
    // MARK: - 不再生成了;
    func stopSpawning(){
        
        playerNode.removeAction(forKey: "Flap")
        playerNode.removeAction(forKey: "Wobble-Flap")
        removeAction(forKey: "spawn")
        //停止产生 obstacle let wallObstacle = SKNode()
        worldNode.enumerateChildNodes(withName: "wallObstacle") { (node, error) in
            node.removeAllActions()
            
            node.enumerateChildNodes(withName: "Obstacle", using: { (node, error) in
                node.removeAllActions()
            })
        }
        worldNode.enumerateChildNodes(withName: "coin") { (node, error) in
            print("coin")
            node.removeAllActions()
        }
    }
    //MARK:- 上下浮动
    func startWobble(){
        let moveUp   = SKAction.moveBy(x: 0, y: 50, duration: 0.5)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = moveUp.reversed()
        let sequence = SKAction.sequence([moveUp,moveDown])
        let repeatWobble = SKAction.repeatForever(sequence)
        playerNode.run(repeatWobble, withKey: "Wobble")
        //MARK:- Emitter juice 加入果酱
        let trailNode = SKNode()
        trailNode.zPosition = 5
        worldNode.addChild(trailNode)
        let emitter = SKEmitterNode(fileNamed: "Trail")!
        emitter.targetNode = trailNode
        playerNode.addChild(emitter)
        
        let playerAnimation = SKAction.animate(with: playerTextures, timePerFrame: 0.07)
        let repeatAction    = SKAction.repeatForever(playerAnimation)
        playerNode.run(repeatAction, withKey: "Wobble-Flap")
    }
    //MARK:- 移动皇冠 (相对于Player的位置)
    func moveCrown(){
        crownNode = playerNode.childNode(withName: "crown") as! SKSpriteNode
        //皇冠上下跳动的时间 < Wobble 0.5s的时间
        let moveUp = SKAction.moveBy(x: 0, y: 30, duration: TimeInterval(0.15))
        moveUp.timingMode = .easeInEaseOut
        let moveDown = moveUp.reversed()
        let sequence = SKAction.sequence([moveUp,moveDown])
        crownNode.run(sequence)
    }
    
    func stopWobble(){
        stopAnimation("Wobble")
        stopAnimation("Wobble-Flap")
    }
    //MARK:- 初始化向上的速度 initVelocity的
    func applyInitialImpluse(){
        initVelocity = CGPoint(x: 0, y: impluse * 1.7)
    }
    
    //MARK:-每次点击touchesBegin时执行此函数;
    func applyImpluse(_ lastUpdateTime:TimeInterval){
        moveCrown()
        initVelocity = CGPoint(x:0,y:impluse)
        angularVelocity = velocityModifier.degreesToRadians()
        lastTouchY = playerNode.position.y
        // 运行拍打的声音
        let flapSoundAction = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
        playerNode.run(flapSoundAction)
    }
    //MARK:- *** 时时更新游戏 update 游戏中每帧要更新的代码放在此处 ***
    func applyInstantlyMovement(_ seconds:TimeInterval){
        
        // 执行Gravity 重力 * 调用Utility CGPoint+Extension
        let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(seconds)
        initVelocity += gravityStep
        
        // 运行Velocity 方向+速度
        let velocityStep = initVelocity * CGFloat(seconds)
        playerNode.position += velocityStep
        
        //MARK:- 更新企鹅的角度
        //1.要转的角度
        if playerNode.position.y < lastTouchY {
            angularVelocity = -velocityModifier.degreesToRadians()
        }
        // 转化角度;
        let angularStep = angularVelocity * CGFloat(seconds)
        playerNode.zRotation += angularStep
        // 限制角度
        playerNode.zRotation = min(max(playerNode.zRotation, minDegree.degreesToRadians()), maxDegree.degreesToRadians())
        
        // 撞到地面了; didBegin 进行物理碰撞检测;
        // 物理体的Y值有变化，所以监测playerNode.position.y的高度是否 < (groundNode.size.height + playerNode.size.height / 2)
        if playerNode.position.y <  (groundNode.size.height + playerNode.size.height / 2) {
            playerNode.position = CGPoint(x: playerNode.position.x, y: (groundNode.size.height + playerNode.size.height / 2))
            // 进入游戏结束state
            stateMachine.enter(GameOverState.self)
        }
        
    }
    //MARK:- 收集金币 COINS
    func collectionCoins(nodeA:SKSpriteNode,nodeB:SKSpriteNode){
        // bodyB is Coin 查看Constant.swift的排序;
        let coinAction = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
        worldNode.run(coinAction)
        // 加入果酱 Juice
        /*
         let emitter = SKEmitterNode(fileNamed: "Coin")!
         emitter.position = nodeA.position
         worldNode.addChild(emitter)
         emitter.run(SKAction.sequence([
         SKAction.wait(forDuration: 0.3),
         SKAction.run {emitter.removeFromParent()}
         ])
         )
         */
        //MARK:-JUICE 建立一个路径，绕企鹅一圈
        //移出B节点;
        nodeB.removeFromParent()
    }
    //MARK: - 重新开始游戏;
    func restartGame(){
        let newScene = GameScene(fileNamed: "GameScene")!
        newScene.size = CGSize(width: SCENE_WIDTH, height: SCENE_HEIGHT)
        newScene.anchorPoint = CGPoint(x: 0, y: 0)
        newScene.scaleMode   = .aspectFill
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(newScene, transition:transition)
    }
    
    //MARK:- 点击屏幕 stateMachines
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self) ///获得点击的位置
        
        /// 判断目前的GameScene场景舞台是哪个state
        switch stateMachine.currentState {
        case is WaitingForTapState:
            ///  stateMachine获取点击位置=>State场景要通过physicsWorld.body进行获得点击点
            guard let body = physicsWorld.body(at: touchLocation) else {
                return
            }
            let playButton = body.node?.childNode(withName: "worldNode")?.childNode(withName: "playButton")
            let startLogo  = body.node?.childNode(withName: "worldNode")?.childNode(withName: "startLogo")
            if (playButton?.contains(touchLocation))! {
                // Hide logo + PlayButton
                playButton?.isHidden = true
                startLogo?.isHidden = true
                stateMachine.enter(PlayingState.self) /// 进入开始游戏;
            }    
        case is PlayingState:
            applyImpluse(lastUpdateTimeInterval)      /// 移动;
        case is GameOverState:
            /// 游戏结束的state
            /// stateMachine获取点击位置
            guard let body = physicsWorld.body(at: touchLocation) else {
                return
            }
            // TapToPlay按钮;
            if let tapToPlay  = body.node?.childNode(withName: "worldNode")?.childNode(withName: "tapToPlay") {
                if tapToPlay.contains(touchLocation){
                    restartGame()
                }
            }
            
        default:
            break
        }
    }
    //MARK:- 物理碰撞 didBegin
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyA:SKPhysicsBody
        let bodyB:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        }else{
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        // 收集硬币
        if bodyA.categoryBitMask == PhysicsCategory.Player && bodyB.categoryBitMask == PhysicsCategory.Coin {
            collectionCoins(nodeA: bodyA.node as! SKSpriteNode, nodeB: bodyB.node as! SKSpriteNode)
        }
        
        // 撞到obscatle
        if bodyA.categoryBitMask == PhysicsCategory.Player && bodyB.categoryBitMask == PhysicsCategory.Obstacle {
            print("scene:player hit the obstacles")
            stateMachine.enter(FallingState.self)
        }
        // 撞到地面
        if bodyA.categoryBitMask == PhysicsCategory.Player && bodyB.categoryBitMask == PhysicsCategory.Ground {
            print("scene:player dropped down to the ground")
            stateMachine.enter(GameOverState.self)
        }
        
        if bodyA.categoryBitMask == PhysicsCategory.Ground && bodyB.categoryBitMask == PhysicsCategory.Crown {
            print("scene:crown dropped down to the ground")
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // 获取时间差
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        dt = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if moveAllowed {
            moveEndlessGround(dt: dt)   // Endless 无限循环地板
            moveEndlessTree(dt: dt)     // 移动Tree
            moveEndlessMountain(dt: dt) // 山
            moveEndlessCloud(dt: dt)    // Endless 云
            /* 一、此处可以直接调用 GameScene的applyImpluse */
            // applyInstantlyMovement(dt)
            /*
             * 二、下列为学习如何调用stateMachine方法
             * (1)、stateMachine.update 时时更新
             * (2)、进入PlayingState的update
             * (3)、PlayingState.update调用 Scene的applyImpluse方法
             */
        }
        stateMachine.update(deltaTime: dt)
    }
    
    public func randomDelay() -> CGFloat {
        let random = CGFloat.random(CGFloat(everySpawnDelay), max: 8.0)// max值载大 间距越大;
        return random
    }
}

更多游戏教程：http://www.iFIERO.com
