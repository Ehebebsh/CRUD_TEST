# 📚 Firestore CRUD 실습 앱

이 프로젝트는 **cloud_firestore** 패키지를 사용하여 Firebase Firestore와 연동된 CRUD(생성, 읽기, 업데이트, 삭제) 기능을 구현하는 Flutter 앱이다. 이 앱을 통해 Firebase Firestore에서 데이터를 관리하는 방법을 학습할 수 있다.

## 🛠️ 1. 실행 과정

### 1.1 패키지 설치
<details>
<summary>cloud_firestore 패키지 설치</summary>
<div markdown="1">

Firestore와 연동하여 CRUD 기능을 구현하기 위해 **cloud_firestore** 패키지를 사용한다. 아래 링크를 통해 패키지를 설치할 수 있다.:

- **패키지 링크**: [cloud_firestore](https://pub.dev/packages/cloud_firestore)

```yaml
dependencies:
  cloud_firestore: latest_version
  firebase_core: latest_version
```

Firebase와 연동하기 위해 firebase_core 패키지도 함께 설치해야 한다.

</div> </details>

### 1.2 Firebase 설정

<details> <summary>Firebase 설정 및 연동</summary> <div markdown="1">
Firebase 프로젝트 생성: Firebase 콘솔에서 새 프로젝트를 생성한다.
앱에 Firebase 추가: 프로젝트에 Android 및 iOS 앱을 추가하고, google-services.json(Android) 또는 GoogleService-Info.plist(iOS)를 다운로드하여 프로젝트에 포함시킨다.
Firebase 초기화: Flutter 앱에서 Firebase를 초기화해야 한다다.
  
```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```
</div> </details>

### 1.3 CRUD 기능 구현
<details> <summary>Firestore CRUD 예제 코드</summary> <div markdown="1">
아래 코드는 Firebase Firestore를 사용하여 기본적인 CRUD 기능을 구현하는 방법을 보여준.

1. 데이터 생성(Create)
```dart
  Future<void> _addItem(String itemName) async {
    await _collectionReference.add({'name': itemName});
  }
```

2. 데이터 읽기(Read)
```dart
StreamBuilder<QuerySnapshot>(
              stream: _collectionReference.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                var items = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index].data() as Map<String, dynamic>;
                      var documentId = items[index].id;

                      return ListTile(
                        title: Text(item['name']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(documentId, item['name']);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteItem(documentId);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
```

3. 데이터 업데이트(Update)
```dart
  Future<void> _updateItem(String documentId, String newName) async {
    await _collectionReference.doc(documentId).update({'name': newName});
  }
```

4. 데이터 삭제(Delete)
```dart
    Future<void> _deleteItem(String documentId) async {
    await _collectionReference.doc(documentId).delete();
  }
```
</div> </details>
