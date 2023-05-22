# Dynamic
<img src = "https://user-images.githubusercontent.com/73861795/211793956-31f8a570-c6dc-4a13-bf4a-beff41d8ffce.png" width="300" height="300"/>

>## 다이나믹 프로젝트
>#### 🗓 개발 기간: 2022.12.21 - 2023.01.11
>#### 👥 개발 인원: iOS 1명
<br/>
<br/>

## 💻 Project Introduction
다이나믹은 GIF 이미지를 사용자 기기 사진앨범에 저장할 수 있게 도와주는 어플입니다.

<br/>
<br/>

## 🍎 Tech Stack
<img src="https://img.shields.io/badge/Xcode 14.2-147EFB?style=flat&logo=Xcode&logoColor=white"/> <img src="https://img.shields.io/badge/Swift 5.0-F05138?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/Combine-B7178C?style=flat&logo=&logoColor=white"/> 

<br/>
<br/>

## 🌐 Main Features of the Project
>### 🗂️ 카테고리 별 GIF

<img src = "https://user-images.githubusercontent.com/73861795/211813537-14e1f41b-2c61-4832-bd74-0390a24be38b.gif" width="231" height="500"/>


<br/>

>### 👆🏻 이미지를 짧게 누르면 원본 이미지를 볼 수 있습니다.

<img src = "https://user-images.githubusercontent.com/73861795/211813909-371ff687-5169-4dd1-8383-e3ac1cf44219.gif" width="231" height="500"/>

<br/>

>### 📥 원본 이미지를 길게 꾹 누르면 사진앨범에 저장할 수 있습니다.

<img src = "https://user-images.githubusercontent.com/73861795/211813968-fc433e88-e549-4f43-a82f-247d83ea5c05.gif" width="231" height="500"/>

<br/>

>### 😍 이미지들을 꾹 누르면 찜리스트에 저장이 가능합니다.

<img src = "https://user-images.githubusercontent.com/73861795/211814206-252646ae-9d1e-432c-b6b9-58803c5926a8.gif" width="231" height="500"/>

<br/>

>### 🔴 찜리스트는 오른쪽 상단 빨간색 버튼을 통해 확인할 수 있습니다.

<img src = "https://user-images.githubusercontent.com/73861795/211815195-4e63b6b8-9b3f-48ba-9ee5-b2aebd2da6cb.gif" width="231" height="500"/>

<br/>
<br/>

## ⚒️ Architecture

<img src = "https://user-images.githubusercontent.com/73861795/211819647-c4231fbd-753b-4efe-a64d-a870a1df6865.png"/>

- Dynamic의 프로젝트 구조를 도식화했습니다.

<br/>

>### MVVM

- MVVM은 뷰컨트롤러는 뷰를 그리는 것만 집중하고, 그 외의 Object관리나, UI로직 처리는 뷰 모델에서 진행하도록 했습니다.

<br/>

<img src = "https://user-images.githubusercontent.com/73861795/210164511-7b747ae0-de84-4f3f-b752-82d9b875182f.png" />

>### 헥사고날 아키텍처

- UI로직은 viewModel, 비즈니스 로직은 UseCase로, 네트워크나 외부 프레임워크 요청은 repository로 하여 각각 계층 별로 presentation Layer, domain Layer, Data layer 로 분리하였습니다.
- 핵사고날 아키텍처의 구조는 비즈니스 로직을 다른 로직으로부터 보호하기위해 각 입출력 포트와 어댑터로 안쪽에 있는 유스케이스(비즈니스로직)가 속한 계층만 아예 분리하여 지키는 구조 입니다.

<br/>

>### Coordinator

- View가 어디에서 사용하더라도 화면 전환을 유연하게 할 수 있게 코디네이터 패턴을 사용하였습니다.
- Parent Coordinator와 Child Coordinator 가지기 때문에 딜리게이트로 상위 코디네이터에 접근이 용이합니다.
- 관리하기 쉽게 Coordinator와 ViewController 1:1 관계를 갖습니다.
- View사이에 Object 데이터 전달도 담당합니다.

<br/>

>### DIContainer

- DIContainer로 의존성 객체 주입을 따로 가지게 했습니다.
- 모듈화 작업을 하면서 DIContainer를 계층별로 나누었습니다.


<br/>

>### ActionPattern

- Combine + Action & Event 패턴을 적용하여 뷰에서 일어나는 이벤트들을 관리해주었습니다.
- View와 ViewModel 간의 통신은 Action, Event라는 두 enum으로 그 명세를 한눈에 볼 수 있어서 편리했습니다.

<br/>
<br/>

## 👨🏻‍💻 Technical Challenge
>### GIFO 라이브러리 사용

- GIFO 라이브러리를 사용하여 GIF 이미지를 보여주었습니다.

<br/>

>### ImageCache 작업

- NSCache를 사용하여 GIF Image 데이터들을 핸들링 했습니다.

<br/>

>### 모듈화 작업

- 각 계층별(3개) 모듈을 만들어 관리 하였습니다.

<br/>


>### Async Await

- 비동기 처리를 Async Await으로 했습니다.

<br/>

>### Combine

- Combine을 사용해보았습니다. 
- RxSwift와 비슷한 점이 많아 금방 적응할 수 있었습니다.


<br/>
<br/>
