import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  String editTextName = "";
  String initTextValue = "";
  TextInputType type = TextInputType.name;
  bool required = false;
  int maxline = 1;
  Function(String) onText;
  TextEditingController _controller;
  Function() onTap;

  EditText(
      {Key key,
      this.editTextName,
      this.type,
      this.required,
      this.maxline,
      this.onText,
      this.onTap,
      this.initTextValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController();
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: TextFormField(
            controller: _controller,
            maxLines: maxline,
            decoration: InputDecoration(
              labelText: editTextName + (required ? " \*" : ""),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(),
              ),
            ),
            keyboardType: type,
            onChanged: (value) {
              onText.call(_controller.text);
            },
            onTap: () {
              onTap.call();
            },
          ),
        ),
      ],
    );
  }
}

class InputText extends StatelessWidget {
  String keyText = "";
  int maxline = 1;
  Function(String) onText;
  TextEditingController controller;

  InputText(
      {Key key, this.maxline, this.onText, this.keyText, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorWidth: 3,
      controller: controller,
      key: Key(keyText),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
      ),
      enableInteractiveSelection: false,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16),
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        onText.call(controller.text);
      },
    );
  }
}

class CustomButton extends StatelessWidget {
  String buttonText = "";
  Function onClick;

  CustomButton({Key key, this.buttonText, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: new EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            fixedSize: Size(110, 56),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.3,
                letterSpacing: 1.1),
          ),
          onPressed: () {
            onClick.call();
          },
        ));
  }
}
