# 🌰 ACON-iOS

> **매번 맛집을 찾느라 고민 중인 당신을 위한 지도앱, Acon**

![Frame 2085665410](https://github.com/user-attachments/assets/6d1640b2-1b26-42ae-9eb0-2887960c8f2c)


<br/>

## 🐿️ Developers
| [이수민](https://github.com/cirtuare) | [김유림](https://github.com/yurim830) | [안재현](https://github.com/Ohjackson) | 
| --- | --- | --- |
| <img src="https://github.com/user-attachments/assets/b4ff5177-333e-48c5-9295-95154c7b5275" width="333"/> | <img src="https://github.com/user-attachments/assets/10e57e7b-610a-4d74-b316-79259a55782e" width="333"/> | <img src="https://github.com/user-attachments/assets/55e7f196-623e-4cb4-b800-2cd40c77f8d5" width="333"/> | 
| <p align="center">`스플래시/로그인` `동네인증` <br>`업로드` `장소 상세`</p> | <p align="center">`장소탐색` <br>`필터링`</p> | <p align="center">`취향탐색` <br>`알럿`</p> |

<br/>

## 🥑 시연영상


[시연영상](https://github.com/user-attachments/assets/74d30cb9-2efc-453f-804b-fb44202cd52d)

#### FLOW: 스플래시 -> 로그인 -> 동네인증 -> 취향탐색 (온보딩) -> 장소탐색 -> 장소상세 -> 업로드


<br/>

## 🥜 Library
| Library | Purpose        | Version                                            |
| ------------------- | ------------------------ | ------------------------------------------------------------ |
| SnapKit             | Auto Layout을 쉽고 간결하게 작성하기 위함 & 가독성 향상| ![SnapKit](https://img.shields.io/badge/SnapKit-5.7.1-purple) |
| Then                | 짧고 간결한 코드 처리 & 가독성 향상   | ![Then](https://img.shields.io/badge/Then-3.0.0-white) |
| Moya           | 간결한 네트워크 요청과 구조화된 관리 방식으로 코드 가독성과 유지보수성 향상        | ![Moya](https://img.shields.io/badge/Moya-15.0.3-pink) |
| Kingfisher          | 비동기 이미지 다운로드, 캐싱 및 메모리 관리   | ![Kingfisher](https://img.shields.io/badge/Kingfisher-8.1.3-yellow) |
| GoogleSignIn          | IDToken 방식 기반 구글 소셜 로그인  | ![GoogleSignIn](https://img.shields.io/badge/GoogleSignIn-8.0.0-orange) |
| NMapsMap          | Naver Maps API를 활용한 지도 서비스 구현 | ![NMapsMao](https://img.shields.io/badge/NMapsMap-3.19.0-green) |
| Lottie        | After Effects 기반 벡터 애니메이션 렌더링 | ![Lottie-](https://img.shields.io/badge/Lottie-4.5.1-skyblue) |


<br/>

## 🥜 Code Convention
> [ACON-iOS Code Convention](https://stripe-shoemaker-907.notion.site/acon-ios-code-convention?pvs=4)
<br/><br/> 스타일쉐어의 [Swift-Style-Guide](https://github.com/StyleShare/swift-style-guide)를 기본으로 합니다.


<br/>


## 🥜 Git Flow & Convention
> [ACON-iOS Git Flow & Convention](https://stripe-shoemaker-907.notion.site/acon-ios-git-flow-convention?pvs=4)

![image](https://github.com/user-attachments/assets/3f566073-2e68-4375-90fe-f4dd529c65f7)

```bash
- FEAT : 새로운 기능 구현
- ADD : Feat 이외의 부수적인 코드 추가, 라이브러리 추가, 새로운 View나 Activity 생성
- SETTING : 세팅 관련
- CHORE : 그 이외의 잡일/ 버전 코드 수정, 패키지 구조 변경, 파일 이동, 가독성이나 변수명, reformat 등
- FIX : 버그, 오류 해결
- DEL : 쓸모없는 코드 및 파일 삭제
- DOCS : README 등의 문서 개정
- REFACTOR : 내부 로직은 변경 하지 않고 기존의 코드를 개선하는 리팩토링 시
```
> Branch Naming Rule : [prefix]/#[issue_num]

<br/>


## 🥜 Foldering
```bash
├── 📁 Application
│   ├── AppDelegate
│   ├── SceneDelegate
│   ├── LaunchScreen
├── 📁 Global
│   ├── 🗂️ Protocols
│   ├── 🗂️ Extensions
│   ├── 🗂️ UIComponents
│   ├── 🗂️ Utils
│   │   ├── 🗂️ Enums
│   │   ├── ScreenUtils
│   │   ├── ObservablePattern
│   ├── 🗂️ Literals
│   │   ├── StringLiterals
│   ├── 🗂️ Settings
│   │   ├── 🗂️ Config
│   │   ├── Info.plist
│   ├── 🗂️ Resources
│   │   ├── 🗂️ Font
│   │   ├── Assets
│   │   │   ├── Colors
├── 📁 Network
│   ├── 🗂️ View1
│   │   ├── 🗂️ DTO
│   │   ├── View1TargetType
│   │   ├── View1Service
│   ├── 🗂️ Base
├── 📁 Presentation
│   ├── 🗂️ View1
│   │   ├── 🗂️ Model
│   │   ├── 🗂️ ViewModel
│   │   ├── 🗂️ View
│   │   │   ├── 🗂️ Cell
│   ├── 🗂️ Base
│   │   ├── BaseNavViewController
│   │   ├── BaseViewController
│   │   ├── BaseView
│   │   ├── BaseCollectionViewCell


```

<br/><br/>
