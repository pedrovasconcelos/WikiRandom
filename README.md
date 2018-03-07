# WikiRandom
Random Wikipedia articles. Exploring MVVM, RxSwift and Moya.

WikiRandom is a very simple app that displays snippets of random Wikipedia articles. The main goal with this project is to explore 3 topics:

#### 1) Moya
For networking, I like to use the Router design pattern suggested in Alamofire docs coupled with a custom class representing the web service. The router is used to manage endpoints in a type-safe way and is responsible for most things related to creating network requests. The custom web service class, in turn, is responsible for triggering requests and provides a clean interface that other parts of the app can use to make network requests and receive domain-specific model objects, instead of raw/json data. At its core, Moya seems to provide functionality similar to what you get with the router pattern, but I’m curious about it and how it would fit in or improve this setup.

#### 2) RxSwift
About time to give it a shot! Also related to 3).

#### 3) MVVM
MVC, as is often implemented in iOS, has some well-known shortcomings. Among the most popular alternative architectures, MVVM looks very promising. Especially with RxSwift for the bindings.

### Install

1. `git clone https://github.com/pedrovasconcelos/WikiRandom.git`
2. `pod install`
3. Open WikiRandom xcworkspace
