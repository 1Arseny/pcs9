import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;

  final TextEditingController _nameController =
  TextEditingController(text: 'Рабкин Артур');
  final TextEditingController _emailController =
  TextEditingController(text: 'artur.rabkin@example.com');
  final TextEditingController _phoneController =
  TextEditingController(text: '+7 123 456-78-90');
  final TextEditingController _avatarUrlController =
  TextEditingController(text: 'https://avatars.dzeninfra.ru/get-zen_doc/1875939/pub_5d0694d862f9700db603f9b7_5d069802353a0c0d81786116/scale_1200');

  final _formKey = GlobalKey<FormState>();

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль сохранен')),
      );
    }
  }

  void _editProfile() {
    setState(() {
      _isEditing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider avatarImage;
    if (_isValidUrl(_avatarUrlController.text)) {
      avatarImage = NetworkImage(_avatarUrlController.text);
    } else {
      avatarImage = const AssetImage('assets/default_avatar.png');
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
          backgroundColor: Colors.blueGrey,
          actions: [
            _isEditing
                ? IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            )
                : IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editProfile,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isEditing
                        ? () {
                    }
                        : null,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: avatarImage,
                      backgroundColor: Colors.grey[200],
                      child: _isEditing
                          ? const Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, color: Colors.black),
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя и фамилия',
                      prefixIcon: Icon(Icons.person, color: Colors.blueGrey),
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditing,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите имя и фамилию';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Электронная почта',
                      prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditing,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите электронную почту';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Введите корректную почту';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Телефон',
                      prefixIcon: Icon(Icons.phone, color: Colors.blueGrey),
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditing,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите номер телефона';
                      }
                      if (!RegExp(r'^\+?\d{7,15}$').hasMatch(value)) {
                        return 'Введите корректный номер телефона';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _avatarUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL аватара',
                      prefixIcon: Icon(Icons.image, color: Colors.blueGrey),
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditing,
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите URL аватара';
                      }
                      if (!Uri.parse(value).isAbsolute) {
                        return 'Введите корректный URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isEditing
                      ? ElevatedButton.icon(
                    onPressed: () {
                      if (_isValidUrl(_avatarUrlController.text)) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Image.network(
                              _avatarUrlController.text,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('Не удалось загрузить изображение');
                              },
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Введите корректный URL для аватара')
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('Предпросмотр аватара'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                  )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidUrl(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (!uri.hasScheme || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      return false;
    }
    return true;
  }
}
