import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';



class mySignIn extends StatefulWidget {
  const mySignIn({Key? key}) : super(key: key);

  @override
  _mySignInState createState() => _mySignInState();
}

class _mySignInState extends State<mySignIn> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoApp'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Image.asset(
                'images/enit.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailTextController,
                decoration: const InputDecoration(
                    hintText: 'Enter Email',
                    border: OutlineInputBorder(),
                    labelText: 'Email'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordTextController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Enter Password',
                    border: OutlineInputBorder(),
                    labelText: 'Password'),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : mySignInButton(context, true, () {
                setState(() {
                  isLoading = true;
                });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
    email: _emailTextController.text,
    password: _passwordTextController.text)
        .then((value) => {
    setState(() {
    isLoading = false;
    }),
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(
    builder: (context) => const HomePage()))
    })
        .onError((error, stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(error.toString()),
    duration: const Duration(seconds: 2),
    ),
    );
    setState(() {
    isLoading = false;
    });
    return <void>{};
    });


              }),
              mySignUpRow(context),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


TextField myTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    style: TextStyle(color: Colors.blue.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.blueAccent,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.blue.withOpacity(0.8)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Colors.blue.shade50,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container mySignInButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    //width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () => onTap(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
      child: Text(
        isLogin ? 'Log In' : 'Sign Up',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

Row mySignUpRow(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Don't have account?",
        style: TextStyle(color: Colors.red),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MySignUp()));
        },
        child: const Text("Sign Up",
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold)),
      )
    ],
  );
}
