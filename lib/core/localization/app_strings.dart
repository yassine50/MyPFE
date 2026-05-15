class AppStrings {
  AppStrings._();

  static int currentLangIndex = 0;

  // ── Onboarding ───────────────────────────────────────────
  static String get onboardingSkip => ['Skip', 'Omite', 'Passer'][currentLangIndex];
  static String get onboardingNext => ['Next', 'Următorul', 'Suivant'][currentLangIndex];
  static String get onboardingGetStarted => ['Get Started', 'Începeți', 'Commencer'][currentLangIndex];
  static String get selectLanguageTitle => ['Select Language', 'Selectează limba', 'Sélectionner la langue'][currentLangIndex];
  static String get selectLanguageSubtitle => ['Please select your preferred language to continue', 'Vă rugăm să selectați limba preferată pentru a continua', 'Veuillez sélectionner votre langue préférée pour continuer'][currentLangIndex];

  // ── Navigation ───────────────────────────────────────────
  static String get navExplore => ['Explore', 'Explorează', 'Explorer'][currentLangIndex];
  static String get navSaved => ['Saved', 'Salvate', 'Enregistré'][currentLangIndex];
  static String get navBookings => ['Bookings', 'Rezervări', 'Réservations'][currentLangIndex];
  static String get navMessages => ['Messages', 'Mesaje', 'Messages'][currentLangIndex];
  static String get navProfile => ['Profile', 'Profil', 'Profil'][currentLangIndex];
  static String get navDashbord => ['Dashboard', 'Panou', 'Tableau de bord'][currentLangIndex];
  static String get navListings => ['Listings', 'Anunțuri', 'Annonces'][currentLangIndex];

  // ── Role Select ──────────────────────────────────────────
  static String get roleSelectTitle => ['How will you use the app?', 'Cum vei folosi aplicația?', 'Comment allez-vous utiliser l\'application ?'][currentLangIndex];
  static String get roleSelectSubtitle => ['To get started, tell us what brings you here today.', 'Pentru a începe, spune-ne ce te aduce aici astăzi.', 'Pour commencer, dites-nous ce qui vous amène ici aujourd\'hui.'][currentLangIndex];
  static String get roleRenterTitle => ['I\'m a Renter', 'Sunt Chiriaș', 'Je suis Locataire'][currentLangIndex];
  static String get roleRenterDesc => ['Browse apartments, co-living spaces, and homes in Romania. Find your next stay effortlessly.', 'Căutați apartamente, spații de co-living și case în România. Găsiți-vă următoarea ședere fără efort.', 'Parcourez les appartements, les espaces de colocation et les maisons en Roumanie. Trouvez votre prochain séjour sans effort.'][currentLangIndex];
  static String get roleRenterButton => ['Find a place', 'Găsește o locuință', 'Trouver un logement'][currentLangIndex];
  static String get roleHostTitle => ['I\'m a Host', 'Sunt Gazdă', 'Je suis Hôte'][currentLangIndex];
  static String get roleHostDesc => ['Earn money by renting out your space to travelers. Simple listing process and secure payments.', 'Câștigați bani închiriind spațiul dumneavoastră călătorilor. Proces simplu de listare și plăți sigure.', 'Gagnez de l\'argent en louant votre espace aux voyageurs. Processus d\'inscription simple et paiements sécurisés.'][currentLangIndex];
  static String get roleHostButton => ['List my property', 'Listează-mi proprietatea', 'Inscrire ma propriété'][currentLangIndex];
  static String get roleTerms => ['By continuing, you agree to our Terms of Service and Privacy Policy.', 'Prin continuarea navigării, ești de acord cu Termenii și Condițiile și cu Politica de Confidențialitate.', 'En continuant, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité.'][currentLangIndex];

  // ── Auth ─────────────────────────────────────────────────
  static String get loginTitle => ['Welcome Back', 'Bine ai revenit', 'Bon retour'][currentLangIndex];
  static String get loginSubtitle => ['Log in to your account', 'Conectează-te la contul tău', 'Connectez-vous à votre compte'][currentLangIndex];
  static String get signUpTitle => ['Create Account', 'Creează cont', 'Créer un compte'][currentLangIndex];
  static String get emailAddress => ['Email Address', 'Adresă de email', 'Adresse e-mail'][currentLangIndex];
  static String get password => ['Password', 'Parolă', 'Mot de passe'][currentLangIndex];
  static String get logIn => ['Log In', 'Autentificare', 'Connexion'][currentLangIndex];
  static String get signUp => ['Sign Up', 'Înregistrare', 'S\'inscrire'][currentLangIndex];
  static String get continueText => ['Continue', 'Continuă', 'Continuer'][currentLangIndex];
  static String get forgotPassword => ['Forgot Password?', 'Ai uitat parola?', 'Mot de passe oublié ?'][currentLangIndex];
  static String get alreadyHaveAccount => ['Already have an account? ', 'Ai deja un cont? ', 'Vous avez déjà un compte ? '][currentLangIndex];
  static String get loginLink => ['Login', 'Autentificare', 'Connexion'][currentLangIndex];
  static String get dontHaveAccount => ['Don\'t have an account? ', 'Nu ai un cont? ', 'Vous n\'avez pas de compte ? '][currentLangIndex];
  static String get signUpLink => ['Sign Up', 'Înregistrare', 'S\'inscrire'][currentLangIndex];
  static String get orContinueWith => ['Or continue with', 'Sau continuă cu', 'Ou continuer avec'][currentLangIndex];

  // ── Common Actions ───────────────────────────────────────
  static String get save => ['Save', 'Salvează', 'Enregistrer'][currentLangIndex];
  static String get cancel => ['Cancel', 'Anulează', 'Annuler'][currentLangIndex];
  static String get close => ['Close', 'Închide', 'Fermer'][currentLangIndex];
  static String get remove => ['Remove', 'Șterge', 'Supprimer'][currentLangIndex];
  static String get share => ['Share', 'Distribuie', 'Partager'][currentLangIndex];
  static String get logOut => ['Log Out', 'Deconectare', 'Déconnexion'][currentLangIndex];
  static String get edit => ['Edit', 'Editează', 'Modifier'][currentLangIndex];
  static String get filter => ['Filter', 'Filtrează', 'Filtrer'][currentLangIndex];
  static String get search => ['Search', 'Caută', 'Rechercher'][currentLangIndex];
  static String get back => ['Back', 'Înapoi', 'Retour'][currentLangIndex];

  // ── Profile ──────────────────────────────────────────────
  static String get profileTitle => ['Profile', 'Profil', 'Profil'][currentLangIndex];
  static String get editProfile => ['Edit Profile', 'Editează profilul', 'Modifier le profil'][currentLangIndex];
  static String get saveChanges => ['Save Changes', 'Salvează modificările', 'Enregistrer les modifications'][currentLangIndex];
  static String get personalDetails => ['Personal Details', 'Detalii personale', 'Détails personnels'][currentLangIndex];
  static String get rentalPreferences => ['Rental Preferences', 'Preferințe de închiriere', 'Préférences de location'][currentLangIndex];
  static String get accountSettings => ['Account Settings', 'Setări cont', 'Paramètres du compte'][currentLangIndex];
  static String get changePhoto => ['Change Photo', 'Schimbă fotografia', 'Changer la photo'][currentLangIndex];
  static String get fullName => ['Full Name', 'Nume complet', 'Nom complet'][currentLangIndex];
  static String get bio => ['Bio', 'Bio', 'Bio'][currentLangIndex];
  static String get nationality => ['Nationality', 'Naționalitate', 'Nationalité'][currentLangIndex];
  static String get preferredLanguage => ['Preferred Language', 'Limbă preferată', 'Langue préférée'][currentLangIndex];
  static String get monthlyBudget => ['Monthly Budget', 'Buget lunar', 'Budget mensuel'][currentLangIndex];
  static String get desiredMoveIn => ['Desired Move-in Date', 'Data de mutare dorită', 'Date d\'emménagement souhaitée'][currentLangIndex];
  static String get profileUpdated => ['Profile updated successfully!', 'Profil actualizat cu succes!', 'Profil mis à jour avec succès !'][currentLangIndex];
  static String get switchToHostMode => ['Switch to Host Mode', 'Comută la modul Gazdă', 'Passer en mode Hôte'][currentLangIndex];
  static String get joinedIn => ['Joined in', 'Alăturat în', 'Inscrit en'][currentLangIndex];
  static String get occupation => ['Occupation', 'Ocupație', 'Profession'][currentLangIndex];
  static String get stays => ['STAYS', 'ȘEDERI', 'SÉJOURS'][currentLangIndex];
  static String get rating => ['RATING', 'RATING', 'ÉVALUATION'][currentLangIndex];
  static String get response => ['RESPONSE', 'RĂSPUNS', 'RÉPONSE'][currentLangIndex];

  // ── Settings ─────────────────────────────────────────────
  static String get settingsTitle => ['Settings', 'Setări', 'Paramètres'][currentLangIndex];
  static String get sectionGeneral => ['GENERAL', 'GENERAL', 'GÉNÉRAL'][currentLangIndex];
  static String get sectionNotifications => ['NOTIFICATIONS', 'NOTIFICĂRI', 'NOTIFICATIONS'][currentLangIndex];
  static String get sectionPayments => ['PAYMENTS & SUBSCRIPTION', 'PLĂȚI ȘI ABONAMENT', 'PAIEMENTS ET ABONNEMENT'][currentLangIndex];
  static String get sectionPrivacy => ['PRIVACY & SECURITY', 'CONFIDENȚIALITATE ȘI SECURITATE', 'CONFIDENTIALITÉ ET SÉCURITÉ'][currentLangIndex];
  static String get sectionSupport => ['SUPPORT', 'ASISTENȚĂ', 'SUPPORT'][currentLangIndex];
  static String get language => ['Language', 'Limbă', 'Langue'][currentLangIndex];
  static String get currency => ['Currency', 'Monedă', 'Devise'][currentLangIndex];
  static String get pushNotifications => ['Push Notifications', 'Notificări Push', 'Notifications Push'][currentLangIndex];
  static String get emailUpdates => ['Email Updates', 'Actualizări prin email', 'Mises à jour par e-mail'][currentLangIndex];
  static String get paymentMethods => ['Payment Methods', 'Metode de plată', 'Modes de paiement'][currentLangIndex];
  static String get billingHistory => ['Billing History', 'Istoric de facturare', 'Historique de facturation'][currentLangIndex];
  static String get changePassword => ['Change Password', 'Schimbă parola', 'Changer le mot de passe'][currentLangIndex];
  static String get faceIdLogin => ['FaceID Login', 'Autentificare FaceID', 'Connexion FaceID'][currentLangIndex];
  static String get helpCenter => ['Help Center', 'Centru de ajutor', 'Centre d\'aide'][currentLangIndex];
  static String get termsOfService => ['Terms of Service', 'Termeni de utilizare', 'Conditions d\'utilisation'][currentLangIndex];

  // ── Booking / Request ────────────────────────────────────
  static String get requestToBook => ['Request to Book', 'Cere rezervarea', 'Demande de réservation'][currentLangIndex];
  static String get tripDetails => ['Trip Details', 'Detalii călătorie', 'Détails du voyage'][currentLangIndex];
  static String get messageLandlord => ['Message the Landlord', 'Trimite mesaj proprietarului', 'Envoyer un message au propriétaire'][currentLangIndex];
  static String get messageLandlordDesc => ['Introduce yourself and mention why you\'d be a great tenant.', 'Prezintă-te și menționează de ce ai fi un chiriaș grozav.', 'Présentez-vous et mentionnez pourquoi vous seriez un excellent locataire.'][currentLangIndex];
  static String get sendRequest => ['Send Request', 'Trimite cererea', 'Envoyer la demande'][currentLangIndex];
  static String get requestSent => ['Request sent successfully!', 'Cerere trimisă cu succes!', 'Demande envoyée avec succès !'][currentLangIndex];
  static String get moveInDate => ['Move-in Date', 'Data mutării', 'Date d\'emménagement'][currentLangIndex];
  static String get moveOutDate => ['Move-out Date', 'Data plecării', 'Date de départ'][currentLangIndex];
  static String get guests => ['Guests', 'Oaspeți', 'Invités'][currentLangIndex];
  static String get serviceFee => ['Service fee', 'Taxă de serviciu', 'Frais de service'][currentLangIndex];
  static String get total => ['Total', 'Total', 'Total'][currentLangIndex];
  static String get notChargedYet => ['You won\'t be charged yet', 'Nu veți fi taxat încă', 'Vous ne serez pas encore facturé'][currentLangIndex];

  // ── My Bookings ──────────────────────────────────────────
  static String get myBookings => ['My Bookings', 'Rezervările mele', 'Mes réservations'][currentLangIndex];
  static String get upcoming => ['Upcoming', 'Viitoare', 'À venir'][currentLangIndex];
  static String get past => ['Past', 'Anterioare', 'Passé'][currentLangIndex];
  static String get cancelled => ['Cancelled', 'Anulate', 'Annulé'][currentLangIndex];
  static String get savedRooms => ['Saved Rooms', 'Camere salvate', 'Chambres enregistrées'][currentLangIndex];

  // ── Inbox / Chat ─────────────────────────────────────────
  static String get inbox => ['Inbox', 'Mesaje', 'Boîte de réception'][currentLangIndex];
  static String get typeMessage => ['Type a message...', 'Scrie un mesaj...', 'Tapez un message...'][currentLangIndex];
  static String get searchMessages => ['Search messages or properties...', 'Caută mesaje sau proprietăți...', 'Rechercher des messages ou des propriétés...'][currentLangIndex];

  // ── Detail Screen ────────────────────────────────────────
  static String get aboutSpace => ['About the space', 'Despre spațiu', 'À propos de l\'espace'][currentLangIndex];
  static String get exactLocationAfterBooking => ['Exact location provided after booking.', 'Locația exactă este furnizată după rezervare.', 'Emplacement exact fourni après la réservation.'][currentLangIndex];

  // ── Home ─────────────────────────────────────────────
  static String get filterNearMetro => ['Near Metro', 'Lângă metrou', 'Près du métro'][currentLangIndex];
  static String get filterColiving => ['Co-living', 'Co-living', 'Colocation'][currentLangIndex];
  static String get featuredListings => ['Featured Listings', 'Anunțuri Recomandate', 'Annonces en vedette'][currentLangIndex];
  static String get bestForColiving => ['Best for Co-living', 'Cel mai bun pentru Co-living', 'Idéal pour colocation'][currentLangIndex];
  static String get seeAll => ['See all', 'Vezi tot', 'Voir tout'][currentLangIndex];
  static String get mapButton => ['Map', 'Hartă', 'Carte'][currentLangIndex];

  // ── Saved ─────────────────────────────────────────────
  static String get savedRoomsTitle => ['Saved Rooms', 'Camere Salvate', 'Chambres Enregistrées'][currentLangIndex];
  static String get filterAllProperties => ['All Properties', 'Toate Proprietățile', 'Toutes les propriétés'][currentLangIndex];
  static String get filterApartments => ['Apartments', 'Apartamente', 'Appartements'][currentLangIndex];
  static String get perMonth => ['/month', '/lună', '/mois'][currentLangIndex];
  static String get removeButton => ['Remove', 'Șterge', 'Retirer'][currentLangIndex];
  static String get sortBy => ['Sort by', 'Sortează după', 'Trier par'][currentLangIndex];
  static String get exportList => ['Export list', 'Exportă lista', 'Exporter la liste'][currentLangIndex];
  static String get shareList => ['Share list', 'Distribuie lista', 'Partager la liste'][currentLangIndex];
  static String get priceLowToHigh => ['Price: Low to High', 'Preț: Mic la Mare', 'Prix : Croissant'][currentLangIndex];
  static String get priceHighToLow => ['Price: High to Low', 'Preț: Mare la Mic', 'Prix : Décroissant'][currentLangIndex];
  static String get dateSaved => ['Date Saved', 'Data Salvării', 'Date d\'enregistrement'][currentLangIndex];

  // ── Inbox ─────────────────────────────────────────────
  static String get filterAll => ['All', 'Toate', 'Tout'][currentLangIndex];
  static String get filterUnread => ['Unread', 'Necitite', 'Non lu'][currentLangIndex];
  static String get filterArchived => ['Archived', 'Arhivate', 'Archivé'][currentLangIndex];
  static String get filterSupport => ['Support', 'Suport', 'Support'][currentLangIndex];
  static String get allCaughtUp => ['You\'re all caught up!', 'Ești la zi!', 'Vous êtes à jour !'][currentLangIndex];
  static String get pastGuest => ['Past Guest', 'Oaspete Anterior', 'Ancien Invité'][currentLangIndex];


  // ── My Bookings (Renter & Host) ──────────────────────────
  static String get bookingHistory => ['Booking History', 'Istoric Rezervări', 'Historique des réservations'][currentLangIndex];
  static String get completedBookings => ['Completed (12)', 'Finalizate (12)', 'Terminé (12)'][currentLangIndex];
  static String get cancelledBookings => ['Cancelled (2)', 'Anulate (2)', 'Annulé (2)'][currentLangIndex];
  static String get allBookings => ['All Bookings', 'Toate rezervările', 'Toutes les réservations'][currentLangIndex];
  static String get modifyBooking => ['Modify Booking', 'Modifică rezervarea', 'Modifier la réservation'][currentLangIndex];
  static String get cancelBooking => ['Cancel Booking', 'Anulează rezervarea', 'Annuler la réservation'][currentLangIndex];
  static String get viewReceipt => ['View Receipt', 'Vezi chitanța', 'Voir le reçu'][currentLangIndex];
  static String get shareDetails => ['Share Details', 'Distribuie detalii', 'Partager les détails'][currentLangIndex];
  static String get keepBooking => ['Keep Booking', 'Păstrează rezervarea', 'Garder la réservation'][currentLangIndex];
  static String get statusConfirmed => ['Confirmed', 'Confirmat', 'Confirmé'][currentLangIndex];
  static String get statusCheckInSoon => ['Check-in Soon', 'Check-in în curând', 'Arrivée bientôt'][currentLangIndex];
  static String get statusSaved => ['Saved', 'Salvat', 'Enregistré'][currentLangIndex];
  static String get btnMessageHost => ['Message Host', 'Mesaj Gazdă', 'Contacter l\'hôte'][currentLangIndex];
  static String get btnViewDetails => ['View Details', 'Vezi detalii', 'Voir les détails'][currentLangIndex];
  static String get btnCompleteBooking => ['Complete Booking', 'Finalizează rezervarea', 'Compléter la réservation'][currentLangIndex];

  // ── Host Dashboard ───────────────────────────────────────
  static String get hostDashboard => ['Host Dashboard', 'Panou Gazdă', 'Tableau de bord de l\'hôte'][currentLangIndex];
  static String get performanceOverview => ['Performance Overview', 'Prezentare Performanță', 'Aperçu des performances'][currentLangIndex];
  static String get monthlyEarnings => ['Monthly Earnings', 'Câștiguri Lunare', 'Gains Mensuels'][currentLangIndex];
  static String get occupancyRate => ['Occupancy Rate', 'Rata de Ocupare', 'Taux d\'Occupation'][currentLangIndex];
  static String get btnNewListing => ['New Listing', 'Anunț Nou', 'Nouvelle Annonce'][currentLangIndex];
  static String get btnSyncCalendar => ['Sync Calendar', 'Sincronizare Calendar', 'Synchroniser le Calendrier'][currentLangIndex];
  static String get activeReservations => ['Active Reservations', 'Rezervări Active', 'Réservations Actives'][currentLangIndex];
  static String get viewAll => ['View all', 'Vezi tot', 'Voir tout'][currentLangIndex];
  static String get recentMessages => ['Recent Messages', 'Mesaje Recente', 'Messages Récents'][currentLangIndex];
  static String get notifications => ['Notifications', 'Notificări', 'Notifications'][currentLangIndex];

  // ── Host My Listing ──────────────────────────────────────
  static String get myListings => ['My Listings', 'Anunțurile Mele', 'Mes Annonces'][currentLangIndex];
  static String get active => ['Active', 'Activ', 'Actif'][currentLangIndex];
  static String get drafts => ['Drafts', 'Ciorne', 'Brouillons'][currentLangIndex];
  static String get hidden => ['Hidden', 'Ascuns', 'Caché'][currentLangIndex];
  static String get allProperties => ['All properties (16)', 'Toate proprietățile (16)', 'Toutes les propriétés (16)'][currentLangIndex];
  static String get editListing => ['Edit Listing', 'Editează Anunțul', 'Modifier l\'Annonce'][currentLangIndex];
  static String get stats => ['Stats', 'Statistici', 'Statistiques'][currentLangIndex];
  static String get preview => ['Preview', 'Previzualizare', 'Aperçu'][currentLangIndex];

  // ── Host My Booking ──────────────────────────────────────
  static String get requests => ['Requests (2)', 'Cereri (2)', 'Demandes (2)'][currentLangIndex];
  static String get history => ['History', 'Istoric', 'Historique'][currentLangIndex];
  static String get newBadge => ['NEW', 'NOU', 'NOUVEAU'][currentLangIndex];
  static String get longTermBadge => ['LONG TERM', 'TERMEN LUNG', 'LONG TERME'][currentLangIndex];
  static String get decline => ['Decline', 'Refuză', 'Refuser'][currentLangIndex];
  static String get accept => ['Accept', 'Acceptă', 'Accepter'][currentLangIndex];
  static String get expires12h => ['Expires in 12h', 'Expiră în 12h', 'Expire dans 12h'][currentLangIndex];
  static String get expires45m => ['Expires in 45m', 'Expiră în 45m', 'Expire dans 45m'][currentLangIndex];

}