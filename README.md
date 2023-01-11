# Dynamic
<img src = "https://user-images.githubusercontent.com/73861795/211793956-31f8a570-c6dc-4a13-bf4a-beff41d8ffce.png" width="300" height="300"/>

>## 다이나믹 프로젝트
>#### 🗓 개발 기간: 2022.12.21 - 2022.01.11
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

<br/>

>### 👆🏻 이미지를 짧게 누르면 원본 이미지를 볼 수 있습니다.

<br/>

>### 📥 원본 이미지를 길게 꾹 누르면 사진앨범에 저장할 수 있습니다.

<br/>

>### 😍 이미지들을 꾹 누르면 찜리스트에 저장이 가능합니다.

<br/>

>### 🔴 찜리스트는 오른쪽 상단 빨간색 버튼을 통해 확인할 수 있습니다.

<br/>
<br/>

## ⚒️ Architecture
<img src = "https://user-images.githubusercontent.com/73861795/210162595-53cf53cf-5f1f-4890-b4ea-740d053b39c1.png" width="817" height="458"/>

>### MVVM

<br/>

<img src = "https://user-images.githubusercontent.com/73861795/210164511-7b747ae0-de84-4f3f-b752-82d9b875182f.png" width="817" height="458"/>

>### 헥사고날 아키텍처(클린 아키텍처)

- 헥사고날 아키텍처는 클린 아키텍처를 좀 더 일반적인 용어로 설명한 것입니다.
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
- Coordinator 안에 객체로 있으며(1:1) 모든 Layer의 의존성을 주입시키고 해당 viewController를 뱉어주는 팩토리로서 사용했습니다.


<br/>
<br/>

## 👨🏻‍💻 Technical Challenge
>### DeskCache 작업

- 서버로 부터 받은 데이터들은 CoreData에 저장하고 불러오게 끔 캐시 작업 하였습니다. 



<br/>


>### Firebase를 활용한 데이터 스트리밍

- firestore를 이용하여  저장하였습니다.
- 뿐만아니라 Authentication, storage를 이용하여 회원정보 관리도 구현하였습니다.

<br/>


>### RxSwift 

- 데이터가 발생하는 시점에서부터 뷰에 그려지기까지 하나의 큰 스트림으로 데이터를 바인딩해주었습니다.

>### Tuist

- Tuist를 사용하여 프로젝트 및 라이브러리들 관리해주었습니다.

<br/>
<br/>
