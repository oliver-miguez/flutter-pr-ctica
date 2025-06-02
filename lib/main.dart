import 'package:flutter/material.dart';
import 'package:programa/menu.dart';

void main() {
  runApp(const MiAppLogin());
}

class MiAppLogin extends StatelessWidget {
  const MiAppLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController(); //Es un controlador que Flutter usa para manejar y controlar el texto que el usuario escribe dentro de un TextField.
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true; //Estado para mostrar o ocultar la contraseña
  /*
  Permite leer el texto que el usuario escribe y también modificarlo programáticamente si quieres.

  Para acceder al texto que el usuario ingresó

  _usuarioController controla el campo de texto donde el usuario escribe su nombre o usuario.
  _passwordController controla el campo de texto donde el usuario escribe la contraseña.
   */

  void _login() {
    String usuario = _usuarioController.text;
    String password = _passwordController.text;
    /*
    if (usuario == 'admin' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Menu()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
    }*/
  }


  //Es el metodo que construye (dibuja) la interfaz gráfica cada vez que Flutter necesita mostrar la pantalla o actualizarla.
  //context es el contexto donde el widget se está construyendo (se usa para acceder a la información de la UI y a otros widgets).
  @override
  Widget build(BuildContext context) {
    return Scaffold( //Scaffold es una estructura básica que te da la "base" visual para tu pantalla, con soporte para app bar, cuerpo, botones flotantes, etc.
      body: Center(
        child: Padding(//Padding añade un espacio de 16 píxeles por todos lados para que el contenido no esté pegado a los bordes.
          padding: const EdgeInsets.all(16.0),
          child: Column( //Column organiza los widgets hijos en vertical, uno debajo del otro.
            mainAxisSize: MainAxisSize.min, // Hace que la columna solo ocupe lo necesario
          children: [
            Text(
                "LOGIN",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2.0
              ),
            ),
            const SizedBox(height: 20),

            /*
            Campo de texto donde el usuario escribe su nombre.
            controller conecta el texto con _usuarioController para manejar su valor.
            InputDecoration le pone una etiqueta y un borde visible alrededor.
            Espacio con SizedBox(height: 20):
            Añade 20 píxeles de espacio vertical.
             */
            SizedBox(
              width: 300,
              child: TextField(
                controller: _usuarioController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                ),
              ),
            ),


            const SizedBox(height: 20), //da un espacio entre contraseña y usuario

            SizedBox(
              width: 300,
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword, // <-- aquí usas la variable para mostrar/ocultar
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),


            const SizedBox(height: 30),
              ElevatedButton(
                onPressed:(){Navigator.push((context), MaterialPageRoute(builder: (context) => Menu()));}, //_login,
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
