import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.purple[800],
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Payment Card Demo",
          ),
        ),
        body: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InputText(
            prefixIcon: Icon(
              Icons.person,
              color: Colors.grey,
              size: 34,
            ),
            label: "Card Name",
          ),
          InputText(
            imageIcon: Image.asset(
              'lib/images/verve.png',
              width: 34,
            ),
            label: "Number",
            inputFormatter: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(19),
              CardNumberInputFormatter(),
            ],
            keyboardType: TextInputType.number,
          ),
          InputText(
            imageIcon: Image.asset(
              'lib/images/cvv.png',
              width: 34,
              color: Colors.grey,
            ),
            label: "CVV",
            inputFormatter: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: TextInputType.number,
          ),
          InputText(
            imageIcon: Image.asset(
              'lib/images/calendar.png',
              width: 34,
              color: Colors.grey,
            ),
            keyboardType: TextInputType.number,
            inputFormatter: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
              CardMonthInputFormatter(),
            ],
            label: "Expiry Date",
          ),
          FlatButton(
            onPressed: () {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("You hit the pay button !"),
                  action: SnackBarAction(
                    label: "Close",
                    onPressed: () {
                      Scaffold.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            },
            child: Text(
              "Pay",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            minWidth: 120,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}

class InputText extends StatelessWidget {
  final String label;
  final prefixIcon;
  final Image imageIcon;
  final Color borderColor;
  final Color backgorundColor;
  final List inputFormatter;
  final keyboardType;

  InputText({
    this.label,
    this.backgorundColor,
    this.borderColor,
    this.prefixIcon,
    this.imageIcon,
    this.inputFormatter,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 6,
            child: TextField(
              keyboardType: this.keyboardType,
              inputFormatters: this.inputFormatter,
              decoration: InputDecoration(
                icon: this.prefixIcon ?? this.imageIcon,
                labelText: this.label,
                labelStyle: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
                fillColor: Colors.grey[200],
                filled: true,
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple[600],
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      // Memisah setiap 2 karakter dengan karakter /
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      // Memberi spasi setiap 4 karakter
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
