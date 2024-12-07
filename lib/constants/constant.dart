const Map<String,String> serviceAccounts = {
  "type": "service_account",
  "project_id": "onlinebids-1df1c",
  "private_key_id": "25c4f188d3a97c17c1c80f1583cc211b28613fa1",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCs0AUBJ9bmND6G\n/mUSWl7Z5EgN8fgvMtaSB56trOVYPRD+2473pffKdDm9uQMAABz1mKmOdqlRIG+H\nLUdDL9IHjqqsRfXjVl8OOhRY/MyHTPBiM0jLOHahOTb6Em2Y70bDy4vwLGMlwIV5\nEV+mQxxJ77xJA38qjkuEu2k86/oZjwwJOL7+Vy9shGImsme5s02zMvCvGCHvIIlg\ns1rdfY+CSCCZ3OQ8wR0PwgihmlD4oMF9npAE7vOq71VPhLRkSCGeN3KkW9mD4jk9\nIgbLP71V8Exrtqn3ZNMjwXThuMq75FrDMjMpowkFZUTUXv+5fYDdVqL3XAsfLgux\nis5/8qqpAgMBAAECggEAEtV2/im/34XpHKBEFqx3suqQuchZwpcZUH/5GLeDpUq+\ne/Ak1DOn3k4tbtJnk8vvXArfy9F94YQV85cJMbbX/o/bZPwY8MZchLnqtsoSZlqJ\nxkINmGxWbXrFVZrFjAnj3fnkje/gfGBPi6LLmFyvDBXPIOv7I4GvlE8yiHu1XayO\nCiMKuBSabUmOAaa1MhTkuo2oeAgJttfEvo5xb0ePXId3FtKj9n9sgZ19pqfNKl6t\nEH/0MBviI9cQdUCLdvZgoiwpf/73Qy2wuyLn81jBobExhQajkVwvp8Q9BH6DatuF\nY/UYWpdmTX2rovjjfebF+xU+iOitpqiTUACb+1IlqQKBgQDWHf2ST0Lvazl4OxhO\nZUrgUNRF8weU9nB8UekDhDPTmoahOXvxRw4RoS3gD/5k2voKP3ig/A+AHnKhPJ71\nTUEEJvQTKM2EdAddfxo65uKnMBe4AROX30kcktYrQGF1LAGZB2dZMxwTn+QQbX5Y\nTcIkyqv7GUjfRoH+mgjerNKAzQKBgQDOna88RUxlWyqlRqHmZ/TYJBSwTR27TR0Y\ntm8EQnBm+ZfmH+QeqfOq0anZ5AwBiwc0SdmQ6W/ihl5oCsLh7YvsZYv232mVzhGp\n6RbmkTQH0B5kWEfCpp/A9j9l60OEUoJHmnpbhj5h+67Kd2G9T0zBkGjT+7Vabbrf\nbTVFlCWhTQKBgQCuDkUiWbJk4/ocxZU1rVvXy30zu6MPMeIw/Xj49dAXlMcaaptZ\ngNRr+mVLflTjcarPB9esrhp/oMC4V4o0iG9wy6WfqYyfvp56H6eX+DaJiCvP1Xgy\n/jz1sFvPXw+aa4KE/qLBvS12uoRv4kJR0CwhMmvpvB0j+7IS4O6S7VRVhQKBgHd1\n7E+osZcYsvuEby9Mg+BEXEHjFIGrAFu9f0qzL1IalZzUa4zfLqdhOhdlJxvtSmkN\nGeITVkFe906oii0er3wq6lX+romS79uRjVAaPD8YMbpK4JLGzC9BMT64W/0xx2mn\nA3/PiloUrucZR0Wxh+uSl0mZiy2RrC5qchacpXUxAoGANJXw167Daf0zfaeDTatN\nbELXBx2OnFiYOhdy5LY8M7Ku/ySh9Dqzpw1nOgxXI8o/MrttTzxD8fusWPiKbBVL\nnlV6sXDATEx7fJ/4RTrOeMG91kKdQLo+SJ3pr1KJklmrNOrYob7Dgjlp4q87hEBt\nJrHRKuuYwHLg2l7A0hGjxco=\n-----END PRIVATE KEY-----\n",
  "client_email": "online-bids@onlinebids-1df1c.iam.gserviceaccount.com",
  "client_id": "104396347983253250619",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/online-bids%40onlinebids-1df1c.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
};

const List<String> uriScope = [
  "https://www.googleapis.com/auth/userinfo.email",
  "https://www.googleapis.com/auth/firbase.database",
  "https://www.googleapis.com/auth/firebase.messaging",
];

const String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/onlinebids-1df1c/messages:send';