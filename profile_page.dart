import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// 名前、生年月日、メールアドレス、電話番号、住所を入力させて登録させる画面を作成せよ。
// 入力したデータはデータベースに格納すること。

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kanaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _name = '';
  String _kana = '';
  String _email = '';
  String _telephone = '';
  String _address = '';

  _storeUserProfile() async {
    // ダイアログの確認結果
    var result = 0;
    // エラーチェック（簡単なnullチェック)
    if (_name.isEmpty || _kana.isEmpty || _email.isEmpty || _telephone.isEmpty || _address.isEmpty) {
      return _alertDialog('入力エラー', '入力データが不足しています。');
    }
    // 登録処理
    List<DocumentSnapshot> _lastUser = [];
    int _lastId; // collectionの中で最新のID取得
    try {
      var snapshotId = await FirebaseFirestore.instance.collection('usersInfo').orderBy('id', descending: true).limit(1).get();
      setState(() {
        _lastUser = snapshotId.docs;
      });
      _lastId = _lastUser[0]['id'];
      int _id = _lastId + 1; // 登録するID

      result = await _confirmDialog('確認ダイアログ', '登録してもよろしいですか？');

      if (result == 1) {
        await FirebaseFirestore.instance.collection('usersInfo').add({
          "id": _id,
          "name": _name,
          "kana": _kana,
          "email": _email,
          "phone": _telephone,
          "address": _address,
        });
        setState(() {
          _name = '';
          _kana = '';
          _email = '';
          _telephone = '';
          _address = '';
        });

        _formClear();
        return _alertDialog('正常終了', '登録が完了しました');
      }
      return;
    } catch (e) {
      print(e);
    }
  }

  _confirmDialog(String title, String text) async {
    var result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(0),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(1),
            ),
          ],
        );
      },
    );
    return result;
  }

  _alertDialog(String title, String text) async {
    return await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _formClear() {
    _nameController.clear();
    _kanaController.clear();
    _telephoneController.clear();
    _emailController.clear();
    _addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // メディアクエリ
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('プロフィール登録'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.all(20),
        color: const Color(0xFFfffff0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction, // 入力時バリデーション
                cursorColor: Colors.blueAccent,
                decoration: const InputDecoration(
                  focusColor: Colors.red,
                  labelText: 'User Name',
                  hintText: 'Enter your Account Name',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "入力してください";
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _kanaController,
                autovalidateMode: AutovalidateMode.onUserInteraction, // 入力時バリデーション
                cursorColor: Colors.blueAccent,
                decoration: const InputDecoration(
                  focusColor: Colors.red,
                  labelText: 'Kana',
                  hintText: 'Enter your Name\'s kana',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    _kana = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "入力してください";
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction, // 入力時バリデーション
                cursorColor: Colors.blueAccent,
                decoration: const InputDecoration(
                  focusColor: Colors.red,
                  labelText: 'E-mail',
                  hintText: 'Enter e-mail address',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "入力してください";
                  }
                  if (value.contains('@') == false) {
                    return "形式が異なっています";
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _telephoneController,
                autovalidateMode: AutovalidateMode.onUserInteraction, // 入力時バリデーション
                cursorColor: Colors.blueAccent,
                decoration: const InputDecoration(
                  focusColor: Colors.red,
                  labelText: 'Phone Number',
                  hintText: 'Enter a Phone Number',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    _telephone = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "入力してください";
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _addressController,
                autovalidateMode: AutovalidateMode.onUserInteraction, // 入力時バリデーション
                cursorColor: Colors.blueAccent,
                decoration: const InputDecoration(
                  focusColor: Colors.red,
                  labelText: 'Address',
                  hintText: 'Enter address',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                ),
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "入力してください";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 50,
              width: size.width * 0.65,
              child: ElevatedButton(
                onPressed: () {
                  _storeUserProfile();
                },
                child: const Text(
                  'プロフィール登録',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  onPrimary: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
