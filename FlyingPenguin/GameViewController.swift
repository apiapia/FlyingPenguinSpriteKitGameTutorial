//  GameScene.swift
//  FlyingPenguin
//
/*
 *  *** 游戏元素使用条款及注意事项 ***
 *
 *  游戏中的所有元素全部由iFIERO所原创(除注明引用之外)，包括人物、音乐、场景等，
 *  创作的初衷就是让更多的游戏爱好者可以在开发游戏中获得自豪感 -- 让手机游戏开发变得简单。
 *  秉着开源分享的原则,iFIERO发布的游戏都尽可能的易懂实用，并开放所有源码，
 *  任何使用者都可以使用游戏中的代码块，也可以进行拷贝、修改、更新、升级，无须再经过iFIERO的同意。
 *  但这并不表示可以任意复制、拆分其中的游戏元素:
 *  用于[商业目的]而不注明出处，
 *  用于[任何教学]而不注明出处,
 *  用于[游戏上架]而不注明出处；
 *  另外,iFIERO有商用授权游戏元素，获得iFIERO官方授权后，即无任何限制！
 *  请尊重帮助过你的iFIERO的知识产权，非常感谢！
 *
 *  Created by VANGO杨 && ANDREW陈
 *  Copyright © 2018 iFiero. All rights reserved.
 *  www.iFIERO.com
 *  iFIERO -- 为游戏开发深感自豪
 *
 *  FlyingPenguin 飞吧企鹅 在此游戏中您将获得如下技能：
 *
 *  1、LaunchScreen       学习如何设置游戏启动画面;
 *  2、Endless Background 无限循环背景;
 *  3、Scene Edit         直接使用可见即所得操作,注意scebe场景的中心点是anchor0.5*0.5;
 *  4、UserDefaults       保存游戏分数、最高分;
 *  5、Random+moveBy      利用可复用的随机函数生成Obstacle障碍物;
 *  6、Juice:Particle     粒子特效;
 *  7、ScreenShot+Share   截屏+分享链接GameScene传值给ViewController;
 *  8、Protocol代理        代理传值保存图片时须设置程序读取手机图片的权限info.plist中的Privicy;
 *  9、StateMachine       GameplayKit 运用之场景;        (**** 中级技能)
 * 10、Entity+Component   Entity对象+Component组件的运用; (**** 中级技能)
 * 11、Velocity+Rotate    Velocity向量(速度+方向)及角度计算;
 * 12、Wobbling           利用moveBy+reverse制作出企鹅上下舞动的效果;
 * 12B、Juice:ScreenShake  Juice特效：学习企鹅撞到障碍物后，整个屏幕发生抖动;(**** 高级技能)
 *
 */


import UIKit
import SpriteKit
import GameplayKit


public let SCENE_WIDTH:CGFloat  = 2048
public let SCENE_HEIGHT:CGFloat = 1536

class GameViewController: UIViewController,GameSceneDelegate {
  
    override func viewDidLoad() {
        
        if let view = self.view as! SKView? {
            if let scene = GameScene(fileNamed: "GameScene") {
                /*
                 * self=>GameViewController,委托scene代理去做二件事
                 * 第一件：screenShot() ，第二件：shareUrl,GameScene做完了后
                 * GameViewController 就调用并实现上面这二件方法
                 */
                scene.gameSceneDelegate = self             // 设置代理为本身(GameViewController)
                scene.anchorPoint = CGPoint(x: 0, y: 0)    // 把场景的中心点设为左下角;
                scene.size = CGSize(width: SCENE_WIDTH, height: SCENE_HEIGHT)
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            /// view.showsPhysics = true 
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
    // 实现GameScene的代理的二个方法
    //MARK:- 抓屏
    func screenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //MARK:- 分享链接
    func shareUrl(_ string: String, url: URL, image: UIImage) {
        print("viewController 分享链接")
        let activityViewController = UIActivityViewController(activityItems: [string, url, image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
