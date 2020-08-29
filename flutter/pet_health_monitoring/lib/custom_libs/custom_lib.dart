import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../strings.dart';

class InputField extends StatelessWidget{
  final double padding;
  final TextEditingController controller;
  final String labelText;
  final double borderRadius;
  final bool isPassword;
  final TextInputType keyBoardType;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  InputField({
    Key key,
    this.padding,
    this.controller,
    this.labelText,
    this.borderRadius,
    this.isPassword,
    this.keyBoardType,
    this.inputFormatters,
    this.maxLength}) : super(key: key);
  @override Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 10),
      child: TextField(
        obscureText: isPassword ?? false,
        keyboardType: keyBoardType,
        inputFormatters: inputFormatters,
        controller: controller,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
          ),
        ),
      ),
    );
  }
}
class HeaderTile extends StatelessWidget{
  final String title;
  HeaderTile({Key key, this.title}) : super(key: key);
  @override Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],),
        textAlign: TextAlign.center,
      ),
    );
  }
}
class FlatButtonWithPadding extends StatelessWidget{
  final VoidCallback onPressed;
  final Color textColor;
  final Color color;
  final String title;
  final double borderRadius;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final double fontSize;
  final FontWeight fontWeight;
  FlatButtonWithPadding({Key key, this.onPressed, this.textColor, this.color, @required this.title, this.borderRadius, this.paddingLeft, this.paddingRight, this.paddingTop, this.paddingBottom, this.fontSize, this.fontWeight}) : super(key: key);
  @override Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: paddingLeft ?? 10,
          right: paddingRight ?? 10,
          top: paddingTop ?? 4,
          bottom: paddingBottom ?? 4),
      child: FlatButton(
        child: Text(title, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),),
        color: color,
        textColor: textColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0),),
        ),
      ),
    );
  }
}
class ButtonWithPadding extends StatelessWidget{
  final VoidCallback onPressed;
  final Color textColor;
  final Color color;
  final String title;
  final double borderRadius;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final double fontSize;
  final FontWeight fontWeight;
  ButtonWithPadding({Key key,@required this.onPressed, this.textColor, this.color, @required this.title, this.borderRadius, this.paddingLeft, this.paddingRight, this.paddingTop, this.paddingBottom, this.fontSize, this.fontWeight}) : super(key: key);
  @override Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: paddingLeft ?? 0,
          right: paddingRight ?? 0,
          top: paddingTop ?? 0,
          bottom: paddingBottom ?? 0),
      child: RaisedButton(
        child: Text(title, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),),
        color: color,
        textColor: textColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0),),
        ),
      ),
    );
  }
}
class CenterCard extends StatelessWidget{
  final Widget child;
  final double borderRadius;
  final double padding;
  CenterCard({Key key, @required this.child, this.borderRadius, this.padding}) : super(key: key);
  @override Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding ?? 20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? 20),
            ),
          ),
          child: Container(
            width: 500,
            child: child,
          ),
        ),
      ),
    );
  }
}
class OutlineCard extends StatelessWidget{
  final Widget child;
  final int borderWidth;
  final Color borderColor;
  final double padding;
  final double margin;

  const OutlineCard({Key key, this.borderWidth, this.borderColor, this.padding, this.margin, @required this.child}) : super(key: key);
  @override Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin ?? 8),
      padding: EdgeInsets.all(padding ?? 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: borderColor ?? Colors.grey[400],
          width: borderWidth ?? 2,
        ),
      ),
      child: child,
    );
  }

}
class FormUi extends StatelessWidget{
  final Widget child;
  final Key scaffoldKey;
  const FormUi({this.scaffoldKey, this.child}) : super();
  @override Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetsImages.farm),
            fit: BoxFit.cover,
          ),
        ),
        child: CenterCard(child: child,),),
    );
  }

}