
import 'package:diapce/Api/abscisa_api.dart';
import 'package:diapce/Providers/slab_provider.dart';
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

  changeStatus({
    required int abscisa_id,
    required String status,
    required BuildContext context
  }) async {
    final abscisaApi = AbscisaApi();
    final abscisa = context.read<AbscisaProvider>();
    final slab = context.read<SlabProvider>();

    final response = await abscisaApi.changeStatus(abscisaId: abscisa_id, status: status);
    
    if (response.statusCode == 200) {
      abscisa.clearAbscisa();
      slab.clearSlabs();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${response.statusCode}'),
        ),
      );
    }
  }
}