import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:party_games_by_tdng/env/env.dart';

String generateJwtToken() {
  String apiKey = Env.apiKey;
  String issuer = Env.issuer;

// Generate a JSON Web Token
// You can provide the payload as a key-value map or a string
  final jwt = JWT(
    /*claims*/ {},
    issuer: issuer,
    audience: Audience([issuer]),
  );

// Sign it (default with HS256 algorithm)

  final token =
      jwt.sign(SecretKey(apiKey), expiresIn: const Duration(seconds: 10));

  return token;
}
