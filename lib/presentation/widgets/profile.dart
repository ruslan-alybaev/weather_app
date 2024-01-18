import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect( // ClipRRect использовали для обрезки углов
      borderRadius: BorderRadius.circular(10),
      child: IconButton(
        onPressed: () {}, 
      icon: const Icon(Icons.person,
      size: 40,
      color: Colors.white,
      ),
      ),
        
      // Также принимает значение clipBehavior
      // Которое в свою очередь принимает в себя след значения
         //  enum Clip {
             // none, // Не обрезать содержимое
             // hardEdge, // Обрезать с жесткими (не-антиалиас) краями
             // antiAlias, // Обрезать с антиалиасингом (плавными) краями
             // antiAliasWithSaveLayer,  // То же, что и antiAlias, но с использованием saveLayer
              // }
    );
  }
}