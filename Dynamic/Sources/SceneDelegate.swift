//
//  SceneDelegate.swift
//  Dynamic
//
//  Created by 김동우 on 2022/12/08.
//

import UIKit

import DynamicCore
import DynamicData
import DynamicDomain
import DynamicPresentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var initCoordinator: Coordinator?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        DIContainer.shared.removeAllValue()
        register()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let tabBarCoordinator: TabBarCoordinator = DIContainer.shared.resolveValue(CodiKeys.tabBar.rawValue) else { return }
        initCoordinator = tabBarCoordinator
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        navigationController.delegate = initCoordinator
        self.initCoordinator?.navigationController = navigationController
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        tabBarCoordinator.start()
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
        DataDIContainer().register()
        DomainDIContainer().register()
        PresentationDIContainer().register()
    }
}
