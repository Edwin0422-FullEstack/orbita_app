import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginDocumentScreen extends ConsumerStatefulWidget {
  const LoginDocumentScreen({super.key});

  @override
  ConsumerState<LoginDocumentScreen> createState() => _LoginDocumentScreenState();
}

class _LoginDocumentScreenState extends ConsumerState<LoginDocumentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _documentoController = TextEditingController();
  String _selectedTipo = 'Cédula de Ciudadanía';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicia sesión"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  "Escribe tu número de documento para continuar",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _selectedTipo,
                  items: const [
                    DropdownMenuItem(value: 'Cédula de Ciudadanía', child: Text('Cédula de Ciudadanía')),
                    DropdownMenuItem(value: 'Cédula de Extranjería', child: Text('Cédula de Extranjería')),
                    DropdownMenuItem(value: 'Pasaporte', child: Text('Pasaporte')),
                  ],
                  onChanged: (val) => setState(() => _selectedTipo = val!),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _documentoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Campo requerido';
                    if (val.length < 6) return 'Número inválido';
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Número de documento',
                    border: OutlineInputBorder(),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Puedes guardar en Riverpod o pasar como parámetro
                      context.push('/login/pin', extra: {
                        'tipo': _selectedTipo,
                        'numero': _documentoController.text,
                      });
                    }
                  },
                  child: const Text('Continuar'),
                ),
                const Spacer(),
                Center(
                  child: TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text('¿No tienes cuenta Orbita?\nCrea tu cuenta aquí'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
