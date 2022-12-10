//
//  SceneDelegate.swift
//  Dynamic
//
//  Created by 김동우 on 2022/12/08.
//

import UIKit

import Core
import Data

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?
    var navigationController: UINavigationController?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.navigationController = UINavigationController()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        register()
        
        guard let mainCoordinator: MainCoordinator = DIContainer.shared.resolveValue("MainCoordinator") else { return }
        
        mainCoordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

private extension SceneDelegate {
    func register() {
        guard let navigationController = navigationController else { return }
        
        DataDIContainer().register()
        DomainDIContainer().register()
        PresentationDIContainer(navigationController: navigationController).register()
    }
}
