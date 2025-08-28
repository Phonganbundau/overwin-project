class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      final errorString = error.toString();
      
      if (errorString.contains('Network error')) {
        return 'Erreur de connexion. Vérifiez votre connexion internet.';
      }
      
      if (errorString.contains('Failed to load data')) {
        return 'Impossible de charger les données. Réessayez plus tard.';
      }
      
      if (errorString.contains('Failed to post data')) {
        return 'Impossible d\'envoyer les données. Réessayez plus tard.';
      }
      
      if (errorString.contains('Invalid email or password')) {
        return 'Email ou mot de passe incorrect.';
      }
      
      if (errorString.contains('User with this email already exists')) {
        return 'Un utilisateur avec cet email existe déjà.';
      }
      
      // Xử lý message xác thực email
      if (errorString.contains('Veuillez vérifier votre email')) {
        return 'Veuillez vérifier votre email avant de vous connecter. Un lien de vérification a été envoyé à votre adresse email.';
      }
      
      // Xử lý các message lỗi khác từ backend
      if (errorString.contains('Login failed:')) {
        // Lấy message gốc từ backend
        final originalMessage = errorString.replaceAll('Login failed: ', '');
        if (originalMessage.contains('Veuillez vérifier votre email')) {
          return 'Veuillez vérifier votre email avant de vous connecter. Un lien de vérification a été envoyé à votre adresse email.';
        }
        return originalMessage;
      }
      
      return 'Une erreur est survenue. Réessayez plus tard.';
    }
    
    return 'Une erreur inattendue est survenue.';
  }
  
  static bool isNetworkError(dynamic error) {
    if (error is Exception) {
      final errorString = error.toString();
      return errorString.contains('Network error') || 
             errorString.contains('Failed to load data') ||
             errorString.contains('Failed to post data');
    }
    return false;
  }
}
