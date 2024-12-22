# Amor
소모임을 만들고 다양한 사람들과 교류하는 앱

## 스크린샷
|라운지|홈|채널 채팅|
|:---:|:----:|:-----:|
|<img width = "200" src = "https://github.com/user-attachments/assets/dfb939c2-1957-42a9-8512-e7078f0fbcce">|<img width = "200" src = "https://github.com/user-attachments/assets/84d01728-adf5-4c8b-bc31-f6810269703d">|<img width = "200" src = "https://github.com/user-attachments/assets/76fc8a82-334b-40f7-a980-7445d1760af3">|

|채널 설정|DM 목록|DM 채팅|
|:-----:|:-----:|:-----:|
|<img width = "200" src = "https://github.com/user-attachments/assets/8bd9e62f-e9a0-455e-93f5-340854e1255c">|<img width = "200" src = "https://github.com/user-attachments/assets/b03e8e80-612d-4076-91ae-0b3e1726f1fc">|<img width = "200" src = "https://github.com/user-attachments/assets/9679b41e-90a9-4ca0-b919-3d6aff23bd36">|

## 프로젝트 환경
- 인원: iOS 2명, 서버 1명
- 기간: 2024.11.25 - 2024.12.19(약 3주)
- 버전: iOS 15+

## 협업관리
### 담당 역할
|김상규|홍정민|
|:--:|:--:|
|<img src="https://avatars.githubusercontent.com/u/134041539?v=4" width=200>|<img src="https://avatars.githubusercontent.com/u/24262395?v=4" width=200>|
|[@skkim125](https://github.com/skkim125)|[@jmzzang](https://github.com/dream7739)|
|홈, 라운지, DM 목록, DM 채팅|채널 채팅, 채널 설정, 안읽은 메시지 카운팅|

### 브랜치 전략
> Github Flow를 기반으로 한 커스텀 브랜치 전략
> 
<img width = "500" src = "https://github.com/user-attachments/assets/eac5fe14-f8b8-48bc-b169-2f6f4aede8da">

- Github 브랜치의 Main 브랜치를 Develop 브랜치로 변경하여 사용
- 각 기능별 Feat 브랜치로 구분하여 개발 및 PR을 통한 분기 병합
- 그 외 Add, Refactor, Fix 등의 브랜치를 용도별로 사용

## 핵심 기능
- 라운지: 라운지 생성 및 참여
- 홈: 내가 속한 채널 및 DM목록 표시
- DM: 최신 주고받은 DM 목록 확인 및 라운지 멤버 탐색 
- 채팅: 실시간 채널, DM 채팅 전송

## 기술 스택
- iOS: Swift, UIKit
- Architecture: Clean Architecture, MVVM + Coordinator, Singleton
- Socket: SocketIO
- DB & Network: Realm, Moya
- Dependency Injection: Swinject
- Reactive: RxSwift, RxDataSources, RxGesture
- UI: UIKeyboardLayoutGuide, SnapKit, Kingfisher, Toast

## 주요 기술
### 프로젝트 주요 기술 
- Clean Architecture를 채택하여 각 계층간의 역할 분리를 통해 의존성 감소 및 유지보수성 증가
- Coordinator 패턴을 통한 화면 전환 로직 분리
- Swinject과 Assembly를 활용한 DI Container를 구현하여 의존성 관리
- NotificationCenter를 사용하여 Background, Foreground 시점의 소켓 단절 및 재연결 처리
- Moya를 활용하여 TargetType 구현 및 네트워크 요청 로직 추상화
- Alamofire RequestInterceptor와 NotificationCenter를 활용한 리프레시 토큰 만료 시점 대응
- Single과 ResultType을 활용한 네트워크 통신 실패 대응
- RxDataSource와 CompositionalLayout을 사용한 다중 섹션 컬렉션뷰 구현

### 기술선택에 있어 고려한 지점들
#### Clean Architecture
<img width="500" alt="CleanArchitecture" src="https://github.com/user-attachments/assets/f0e60da0-184f-468a-8a50-49feaaae27cd" />

> ViewModel이 비대해지는 문제점
- 네트워크, 데이터베이스, 소켓통신과 관련된 작업들이 ViewModel에 존재하며 너무 많은 일을 수행하게 됨
- ViewModel이 비대해지며 프로젝트의 유지보수성이 저하

> Clean Architecture로 각 계층의 역할 분리
- Presentation, Domain, Data 계층으로 나누어 역할 분리
- 비즈니스 로직이 UseCase를 통해 이루어짐으로써 비대한 ViewModel 문제 해결
- UseCase가 Repository구현체가 아닌 Protocol을 소유하도록 하였으며 이를 통해 데이터소스 변경사항에 유연하게 대응하도록 함
  
### Coordinator
<img width="500" alt="Coordinator" src="https://github.com/user-attachments/assets/e27bca3e-afcc-4d35-81be-5f960cc9a202" />

> 화면 전환로직이 ViewController에 혼재되어있는 문제점
- 화면이 많아질수록 ViewController에 화면전환 로직이 혼재되어 추적이 어렵고 관리가 어려워짐
- 화면전환 플로우를 Coordinator가 관리함으로써 ViewController 간 결합도 감소
  
> Coordinator의 역할에 대한 기준 설정
- 화면전환 시에 값을 전달하는 경우에는 Coordinator가 해당 인자를 받아서 화면전환 되도록 구성
- 그와 상관없는 데이터나 로직은 Coordinator가 가지고 있지 않도록 함

### Swinject


## 트러블 슈팅
> 쓸모 없는 유즈케이스와 비대한 뷰모델에서 벗어나기

> 홈화면에서 일어나는 네트워크 통신을 줄이기

> 소켓에서 메시지 수신은 어떻게 전달해야 하며, 언제 끊어 줘야 할까?

## 회고
- 유즈케이스에서 여러 도메인 모델에 접근하는 로직을 처리하면서, 해당 도메인에서 처리할 수 있는 로직도 함께 들고 있는 경우가 있었음. 도메인 모델에서 처리할 수 있는 작업을 처리하도록 한다면 더 명확한 역할 분리를 할 수 있지 않을까 생각이 듬 

- 코디네이터 패턴에서 뷰컨트롤러가 코디네이터를 들고 있게 됨으로써 뷰모델만 독립적으로 테스트할 경우를 가정했을 때 화면전환에 대한 테스트가 불가능해지는 문제점이 있을 것이라고 생각함. 이 부분에 있어서 뷰모델이 코디네이터를 가지고 있는 것이 규모가 있는 앱에서는 더 합리적인 선택이 되지 않을까라는 생각을 했음
