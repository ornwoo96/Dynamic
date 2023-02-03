//
//  UIImage+GIF.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit
import ImageIO

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

extension UIImage {
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        // MARK: 1. 가져온 데이터를 가지고 CGData 형식으로 CGImageSourceCreateWithData 에 넣어준다.
        // MARK: 2. return 값으로 CGImageSource을 준다
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    
    // CGImageSource 안에 있는 image들의 딜레이 타임을 계산
    // 다음보여질 이미지와 이전 이미지 사이의 타임을 계산해주는 함수
    class func delayForImageAtIndex(_ index: Int,
                                    source: CGImageSource!) -> Double {
        var delay = 0.1
        // MARK: Image source 에 있는 모든 이미지 정보 속성들을 추출할 수 있도록 딕셔너리를 제공
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        // Unmanaged.passUnretained(객체).toOpaque()
        // 로 해당 객체의 메모리 주소를 프린트 할 수 있습니다.
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        // kCGImagePropertyGIFUnclampedDelayTime 값을 통해 GIF Image Data 안에 있는 index 값으로 delay 타임의 딕셔너리를 알수 있음
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        // kCGImagePropertyGIFDelayTime 딜레이 값이 100밀리초로 고정해놓고 보낸다.
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                                        to: AnyObject.self)
        }
        delay = delayObject as! Double
        if delay < 0.1 {
            delay = 0.1
        }
        return delay
    }
    
    // MARK: 어떤 작업 때문에 하는 것일까?
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        if a < b {
            let c = a
            a = b
            b = c
        }
        var rest: Int
        while true {
            rest = a! % b!
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        // MARK: 아까받은 CGImageSource에 데이터 안에 몇개의 CGImage들이 있는 지 확인할 수 있는 함수
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }
        let duration: Int = {
            var sum = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        return animation
    }
}

