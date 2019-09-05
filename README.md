# SwiftImageBeauty
便利所有的像素点，给图片加入美白算法

            /// 获取颜色的UInt32表示形式
            fileprivate var rgbaValue:UInt32 {
                var red:CGFloat = 0
                var green:CGFloat = 0
                var blue:CGFloat = 0
                var alpha:CGFloat = 0
                getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                return UInt32(red * 255) << 0 | UInt32(green * 255) << 8 | UInt32(blue * 255) << 16 | UInt32(alpha * 255) << 24
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

项目中利用元组传值的时候主要会把原来的元素copy成另一份出来的
使用的时候要慎重
                
                
