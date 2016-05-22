Hangman-Game-iOS
================

一个简单的Hangman Game小游戏

花了10小时左右写完(作业太多T T本来有48小时啊)......但是有很多地方还需要改进，尤其是细节......

## 如何使用

项目中用到了两个第三方库：[facebook/Shimmer](https://github.com/facebook/Shimmer), [AFNetworking/AFNetworking](https://github.com/AFNetworking/AFNetworking)

需要[CocoaPods](http://cocoapods.org/)来安装依赖

#### Podfile

```ruby
platform :ios, '7.0'
pod 'AFNetworking', '~> 2.2'
pod 'Shimmer', '~> 1.0.1'
```
打开Terminal，进入项目根目录，运行如下命令

```shell
$ pod install
```

运行完后会生成一个Xcode workspace (```.xcworkspace```) 文件

```shell
$ open <YourProjectName>.xcworkspace
```
