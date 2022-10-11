class ErrorHandler {
  static Map<String, String> err(String msg) {
    print("err: " + msg);
    String errorMessage = "Problème de connexion internet.";
    String buttonTxt = "OK";
    if (msg.toString().contains('emailAlreadyRequested')) {
      errorMessage = 'Vous avez déjà reçu un email de confirmation.';
      buttonTxt = "OK";
    } else if (msg.toString().contains('emailSendError')) {
      errorMessage = "Une erreur est survenue lors de l'envoi de l'email.";
      buttonTxt = "Fermer";
    } else if (msg.toString().contains('invalidPassword')) {
      errorMessage = 'Mot de passe incorrect. Essayer de nouveau.';
      buttonTxt = "OK";
    } else if (msg.toString().contains('agentNotFound')) {
      errorMessage = 'Cette adresse email est introuvable. Essayer de nouveau.';
      buttonTxt = "OK";
    } else if (msg.toString().contains('userNotFound')) {
      errorMessage = 'Veuillez confirmer votre adresse e-mail.';
      buttonTxt = "OK";
    } else if (msg.toString().contains('Connection failed')) {
      errorMessage = "Vous n'êtes pas connecté à internet !";
      buttonTxt = "OK";
    } else if (msg.toString().contains('noTicket')) {
      errorMessage = "Vérifier le numéro de Ticket";
      buttonTxt = "OK";
    } else if (msg.toString().contains('notNumber')) {
      //notNumber
      errorMessage = "Le numéro de Ticket n'est pas valide !";
      buttonTxt = "OK";
    }
    // else if (msg.toString().contains('noSold')) {
    //   errorMessage = "sold date !";
    //   buttonTxt = "OK";
    // }
    else if (msg.toString().contains('userBlocked')) {
      errorMessage = "Votre accès est restreint";
      buttonTxt = "OK";
    }
    return {'errorMessage': errorMessage, 'buttonTxt': buttonTxt};
  }
}
