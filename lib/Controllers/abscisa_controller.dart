
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/abscisa_provider.dart';

class AbscisaController {

  create({
    required String name,
    required int numberOfAbscisas,
    required int projectId,
    required BuildContext context
  }) async {
    final abscisa = Provider.of<AbscisaProvider>(context, listen: false);
    await abscisa.create(name: name, numberOfAbscisas: numberOfAbscisas, projectId: projectId);
  }
}