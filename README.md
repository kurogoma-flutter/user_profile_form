# user_profile_form
シンプルなユーザー登録のフォーム

<br>

## 画面・結果

<table>
  <tr>
    <th>フォーム全体</th>
    <th>バリデーションエラー</th>
    <th>確認ダイアログ</th>
    <th>登録完了ダイアログ</th>
  </tr>
  <tr>
    <td>
      <img width="300" src="https://user-images.githubusercontent.com/67848399/159878805-89641c20-4d19-4e99-8f8c-777249a51165.png">
    </td>
    <td>
      <img width="300" src="https://user-images.githubusercontent.com/67848399/159878823-a1ab86e1-979e-4b88-8d85-b9b0963a8f74.png">
    </td>
    <td>
      <img width="300" src="https://user-images.githubusercontent.com/67848399/159878827-ecce7fde-b3f0-4ad8-8b3b-30d8be395e3b.png">
    </td>
    <td>
      <img width="300" src="https://user-images.githubusercontent.com/67848399/159878834-d47fa1ea-8af3-4d8c-8882-af12afb8d750.png">
    </td>
  </tr>
</table>


## コード部分
### TextFormField部分
```dart
TextFormField(
  controller: _nameController, // コントローラーを指定 ➡︎ フォームが5個なら5個作らないとダメ・・・？
  autovalidateMode: AutovalidateMode.onUserInteraction, // 入力時にバリデーションを実行する（ちょっと鬱陶しい）
  cursorColor: Colors.blueAccent,
  decoration: const InputDecoration(
    focusColor: Colors.red,
    labelText: 'User Name',
    hintText: 'Enter your Account Name',
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
    border: OutlineInputBorder(borderSide: BorderSide()),
  ),
  maxLines: 1,
  // 内部的に変数を更新する必要がある
  onChanged: (value) {
    setState(() {
      _name = value;
    });
  },
  // バリデーションの設定ができる。contain('@')などでアドレス形式の判別なども可能。
  validator: (value) {
    if (value == null || value.isEmpty) {
      return "入力してください";
    }
    return null;
  },
),
```
TextFieldウィジェットの方が良い場合もあるらしい？が、基本TextFormFieldの方が上位互換なので
そちらを使う方針でやっていくようにする。
