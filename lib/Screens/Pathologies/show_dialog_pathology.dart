import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Future dialogBuilderPathology(BuildContext context, String imageUrl) {
  return showDialog(
    context: context, 
    builder: (context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 5,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.close, color: Colors.black, size: 20),
                ),
              ),
            ),
            Positioned(
              top: 50,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 100,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(color: Colors.grey[300]),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 100,
                    alignment: Alignment.center,
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}