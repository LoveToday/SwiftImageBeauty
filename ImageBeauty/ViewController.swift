//
//  ViewController.swift
//  ImageBeauty
//
//  Created by ChenJiangLin on 2019/9/5.
//  Copyright © 2019 ChenJiangLin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newImgV: UIImageView!
    var image: UIImage?
    var newColors: [Int] = []
    var myPixels: Array<UInt32>?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let image = UIImage(named: "take_vote.jpg") else { return }
        
        
        
        self.newImgV.image = configImage(image: image)
    }
    /// 使用映射表对图片进行美白 从而代替最小二乘法
    
    // 将普通图片转成位图
    func configImage(image: UIImage)->UIImage?{
        /// 获取image对应的Data
//        let result = self.convertUIImageToData(image: image)
        guard let imageRef = image.cgImage else {
            return nil
        }
        let width = imageRef.width
        let height = imageRef.height
        /// 最为所有的像素点的容器
        var pixels = Array<UInt32>(repeating: 0, count: width * height)
        /// 像素点的颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        /// 颜色空间每个通道占用的bit
        let bitsPerComponent = 8
        /// image每一行所占用的
        let bytesPerRow = width * 4
        /// rgba
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: &pixels, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        context.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        
        let colors = getModels()
        ///便利所有的像素点
        for i in 0..<pixels.count {
            let color = pixels[i]
            let colorRed = Int((color >> 0)&0xff)
            let colorGreen = Int((color >> 8)&0xff)
            let colorBlue = Int((color >> 16)&0xff)
            let colorAlpha = Int((color >> 24)&0xff)
            
            let newColorRed = colors[colorRed]
            let newColorGreen = colors[colorGreen]
            let newColorBlue = colors[colorBlue]
            let newColorApla = colors[colorAlpha]
            let newValue = UInt32(newColorRed) << 0 | UInt32(newColorGreen) << 8 | UInt32(newColorBlue) << 16 | UInt32(newColorApla) << 24
            pixels[i] = newValue
        }
        if let resultCGImage = context.makeImage(){
            return UIImage(cgImage: resultCGImage)
        }
        
        return nil
        
    }
    /// 将UIImage转成位图
    func convertUIImageToData(image: UIImage) -> (Array<UInt32>?, CGContext?){
        guard let imageRef = image.cgImage else {
            return (nil, nil)
        }
        let width = imageRef.width
        let height = imageRef.height
        /// 最为所有的像素点的容器
        var pixels = Array<UInt32>(repeating: 0, count: width * height)
        /// 像素点的颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        /// 颜色空间每个通道占用的bit
        let bitsPerComponent = 8
        /// image每一行所占用的
        let bytesPerRow = width * 4
        /// rgba
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let context = CGContext(data: &pixels, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else { return (nil, nil) }
        context.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        self.myPixels = pixels
        return (pixels, context)
    }
    /// 利用映射表得到的颜色对应值
    func getModels()->[Int]{
        let baseColors: [Int] = [55, 110, 155, 185, 220, 240, 250, 255]
        var newColors: [Int] = []
        var beforeNum: Int = 0
        let distance = 32
        for i in 0..<baseColors.count {
            let num = baseColors[i]
            var step: Float = 0
            if i == 0 {
                step = Float(num)/Float(distance)
            } else {
                step = Float((num - beforeNum))/Float(distance)
            }
            for j in 0..<distance{
                var newNum: Int = 0
                if i == 0 {
                    newNum = Int(Float(j) * step)
                }else{
                    newNum = Int(beforeNum + Int(Float(j) * step))
                }
                newColors.append(newNum)
            }
            beforeNum = num
        }
        return newColors
    }
    


}
extension UIColor {
    /// 获取颜色的UInt32表示形式
    fileprivate var rgbaValue:UInt32 {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UInt32(red * 255) << 0 | UInt32(green * 255) << 8 | UInt32(blue * 255) << 16 | UInt32(alpha * 255) << 24
    }
}

