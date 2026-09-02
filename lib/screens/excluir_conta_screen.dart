import 'package:flutter/material.dart';
import 'package:horas_v3/services/auth_service.dart';

class ExcluirContaScreen extends StatefulWidget {
  const ExcluirContaScreen({super.key});

  @override
  State<ExcluirContaScreen> createState() => _ExcluirContaScreenState();
}

class _ExcluirContaScreenState extends State<ExcluirContaScreen> {
  final _senhaController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _estaCarregando = false;
  String? _mensagemErro;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  void _executarExclusao() async {
    setState(() {
      _mensagemErro = null;
      _estaCarregando = true;
    });

    String senha = _senhaController.text.trim();

    if (senha.isEmpty) {
      setState(() {
        _mensagemErro = 'Por favor, digite sua senha.';
        _estaCarregando = false;
      });
      return;
    }

    String? erro = await _authService.excluirConta(senha: senha);

    if (!mounted) return;

    if (erro != null) {
      setState(() {
        _mensagemErro = erro;
        _estaCarregando = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta excluída com sucesso!')),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excluir Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Atenção! Esta ação é permanente.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text('Digite sua senha para confirmar:'),
            const SizedBox(height: 8),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            if (_mensagemErro != null) ...[
              const SizedBox(height: 12),
              Text(
                _mensagemErro!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            _estaCarregando
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: _executarExclusao,
              child: const Text('Excluir minha conta'),
            ),
          ],
        ),
      ),
    );
  }
}