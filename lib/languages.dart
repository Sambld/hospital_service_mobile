import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'FR': {
          'Login to your account': 'connecter a votre compte ',
          'Log in': 'Connexion',
          'Sign Out': 'Se déconnecter',
          'Welcome back': 'Bienvenue',
          "Welcome": "Bienvenue",
          'Dashboard': 'Tableau de bord',
          'Patient' : 'Patient',
          'Patients': 'Patients',
          'My Patients': 'Mes patients',
          'My Medical Records': 'Mes dossiers médicaux',
          'Doctor': 'Medecin: ',
          'Login': 'Connexion',
          'Patient Details': 'Détails du patient',
          'Add new Patient': 'Ajouter un nouveau patient',
          'Edit Patient': 'Modifier patient',
          'Search': 'Rechercher',
          'Day': 'Jour',
          'No': 'Non',
          'Yes': 'Oui',
          /////////////////////////////////
          'Medical Record Details': 'Détails du dossier médical',
          'Medical Records': 'Dossiers médicaux',
          'Medical Record': 'Dossier médical',
          'View Details': 'Voir les détails',
          "Show only active records": "Afficher uniquement les dossiers actifs",
          'Add Medical Record': 'Ajouter un dossier médical',
          'Add New Medical Record': 'nouveau dossier médical',
          'No medical records found': 'Aucun dossier médical trouvé',
          'Edit Medical Record': 'Modifier dossier médical',
          "Active": "Actif",
          "Closed": "Fermé",
          "Condition": "État",
          "Status": "Statut",
          'Other': 'Autre',
          "infectious diseases": "maladies infectieuses",
          "Patient Entering Date": "Date d'entrée du patient",
          "Patient Entering Date is required":
              "La date d'entrée du patient est obligatoire",
          "Patient Leaving Date": "Date de sortie du patient",
          "Medical Specialty": "Spécialité médicale",
          "Medical Specialty is required":
              "La spécialité médicale est obligatoire",
          "Condition Description": "Description de l'état",
          "Condition Description is required":
              "La description de l'état est obligatoire",
          "Bed Number": "Numéro de lit",
          "Bed Number is required": "Le numéro de lit est obligatoire",
          "Standard Treatment": "Traitement standard",
          "Standard Treatment is required":
              "Le traitement standard est obligatoire",
          "State Upon Enter": "État à l'entrée",
          'State Upon Enter is required': "L'état à l'entrée est obligatoire",
          "State Upon Exit": "État à la sortie",
          "Leaving Information": "Informations de sortie",
          "Leaving Date": "Date de sortie",

          ////////////////////////////
          'Observations': 'Observations',
          'Observation': 'Observation',
          'Add Observation': 'Ajouter une observation',
          'Edit Observation Name': "Modifier le nom de l'observation",
          "Add photo from camera": "Ajouter une photo de la caméra",
          "Add photo from gallery": "Ajouter une photo de la galerie",
          'Photos': 'Photos',
          'Date': 'Date',
          "No Complementary Examinations Found":
              "Aucun examen complémentaire trouvé",
          'Complementary Examinations': 'Examens Complémentaires',
          'Complementary Examination': 'Examen complémentaire',
          'Add Complementary Examination': 'Ajouter un examen complémentaire',
          'Edit Complementary Examination': "Modifier l'examen complémentaire",
          'Monitoring Sheet': 'feuille de surveillance ',
          'Monitoring Sheets': 'feuilles de surveillance ',
          'Update Monitoring Sheet Day':
              'Mettre à jour le jour de la feuille de suivi',
          'Monitoring Sheet': 'Feuille de surveillance',
          'Add Monitoring Sheet Day': 'Ajouter un jour de feuille de suivi',
          "No Monitoring Sheet found": "Aucune feuille de suivi trouvée",
          'Add Monitoring Sheet Day': 'Ajouter un jour de feuille de suivi',
          'Update Monitoring Sheet Treatments':
              'Mettre à jour les traitements de la feuille de suivi',
          'Medicine': 'Médicament',
          'Medicine Requests': 'Demandes des médicaments',
          'Medicine Request': 'Demande de médicament',
          'Medicine Quantity': 'Quantité de médicament',
          'Add Medicine Request': 'Ajouter une demande de médicament',
          'Edit Medicine Request': 'Modifier la demande de médicament',
          'Logout': 'Déconnexion',
          "In Hospital Only": "Seulement à l'hôpital",
          'Home': 'Home',
          'Name': 'Nom',
          'First Name': 'nom',
          'Last Name': 'prénom',
          'First name is required': 'Le prénom est obligatoire',
          'Last name is required': 'Le nom de famille est obligatoire',
          'Gender': 'Genre',
          'Age': 'Âge',
          'Address': 'Adresse',
          'Address is required': "L'adresse est obligatoire",
          'Phone Number': 'téléphone',
          'Phone number is required': 'Le numéro de téléphone est obligatoire',
          'Place of Birth': 'Lieu de naissance',
          'Birth Date': 'Date de naissance',
          'Birth date is required': 'La date de naissance est obligatoire',
          'Nationality': 'Nationalité',
          'Nationality is required': 'La nationalité est obligatoire',
          'Family Situation': 'Situation familiale',
          'No Family Situation': 'Pas de situation familiale',
          'Emergency Contact Phone Number': "téléphone de contact d'urgence",
          'No Emergency Contact': "Aucun contact d'urgence",
          'Emergency Contact Name': "Nom du contact d'urgence",
          'Checkup': 'Check-up',
          'Result': 'Résultat',
          "Today": "Aujourd'hui",
          "Update": "Mettre à jour",
          'Edit': 'Modifier',
          'Save': 'Enregistrer',
          "Cancel": "Annuler",
          "Delete": "Supprimer",
          "Add": "Ajouter",
          "Empty": "Vide",
          "Fill": "Remplir",
          "Filled by": "Rempli par",
          'Temperature': 'Température',
          'Blood Pressure': 'A.T',
          'Urine': 'Urine',
          'Weight': 'Poids',
          'Report': 'Rapport',
          'Treatments': 'Traitements',
          'Add Treatment': 'Ajouter un traitement',
          'Dose': 'Dose',
          'Injection': 'injection',
          'Oral' : 'Oral',
          'Topical': 'Topique',
          'Tablet': 'comprimé',
          'Syrup': 'Sirop',
          'Treatment Type': 'Type de traitement',
          'Update Treatments': 'Mettre à jour les traitements',
          'Delete Treatment': 'Supprimer le traitement',
          'Are you sure you want to delete this treatment?':
              'Êtes-vous sûr de vouloir supprimer ce traitement?',
          'Are you sure you want to delete this complementary examination?':
              'Êtes-vous sûr de vouloir supprimer cet examen complémentaire?',
          'Delete Complementary Examination':
              'Supprimer l\'examen complémentaire',
          'Are you sure you want to delete this medicine request?':
              'Êtes-vous sûr de vouloir supprimer cette demande de médicament?',
          "Are you sure you want to delete this image?":
              "Êtes-vous sûr de vouloir supprimer cette image?",
          'All': 'Tout',
          'Pending': 'En attente',
          'Approved': 'Approuvé',
          'Rejected': 'Rejeté',
          'Quantity': 'Quantité',
          'Review': 'Review',

          'Created At': 'Créé à',
          'Active only': 'Actif seulement',
          'Mine only' : 'Le mien seulement',
        },
        'EN': {
          'Patient' : 'Patient',

          'Log in': 'Log in',
          'Login to your account': 'Login to your account',
          'Sign Out': 'Sign Out',
          'Welcome back': 'Welcome back',
          "Welcome": "Welcome",
          'Dashboard': 'Dashboard',
          'Patients': 'Patients',
          'My Patients': 'My Patients',
          'My Medical Records': 'My Medical Records',
          'Doctor': 'Doctor',
          'Login': 'Login',
          'Patient Details': 'Patient Details',
          'Add Patient': 'Add Patient',
          'Edit Patient': 'Edit Patient',
          'Search': 'Search',
          "In Hospital Only": "In Hospital Only",
          'Day': 'Day',
          'No': 'No',
          'Yes': 'Yes',
          //////////////////////////////////////////
          'Medical Record Details': 'Medical Record Details',
          'Medical Records': 'Medical Records',
          'View Details': 'View Details',
          'Add Medical Record': 'Add Medical Record',
          'Add New Medical Record': 'Add Medical Record',
          'Edit Medical Record': 'Edit Medical Record',
          "Show only active records": "Show only active records",
          "Active": "Active",
          "Closed": "Closed",
          "Status": "Status",
          "Condition": "Condition",
          'Other': 'Other',
          "infectious diseases": "infectious diseases",
          "Patient Entering Date": "Patient Entering Date",
          "Patient Entering Date is required":
              "Patient Entering Date is required",
          'Medicine': 'Medicine',
          "Patient Leaving Date": "Patient Leaving Date",
          "Medical Specialty": "Medical Specialty",
          "Medical Specialty is required": "Medical Specialty is required",
          "Condition Description": "Condition Description",
          "Condition Description is required":
              "Condition Description is required",
          "Bed Number": "Bed Number",
          "Bed Number is required": "Bed Number is required",
          "Standard Treatment": "Standard Treatment",
          "Standard Treatment is required": "Standard Treatment is required",
          "State Upon Enter": "State upon Entering",
          'State Upon Enter is required': "State upon Entering is required",
          "State Upon Exit": "State upon Exiting",
          "Leaving Information": "Leaving Information",
          "Leaving Date": "Leaving Date",
          //////////////////////////////////////////
          'Observations': 'Observations',
          'Observation': 'Observation',
          'Add Observation': 'Add Observation',
          'Edit Observation': 'Edit Observation',
          "Add photo from camera": "Add photo from camera",
          "Add photo from gallery": "Add photo from gallery",
          'Photos': 'Photos',
          'Date': 'Date',
          'Complementary Examinations': 'Complementary Examinations',
          'Complementary Examination': 'Complementary Examination',
          "No Complementary Examinations Found":
              "No complementary cxaminations found",
          'Add Complementary Examination': 'Add Complementary Examination',
          'Edit Complementary Examination': 'Edit Complementary Examination',
          'Monitoring Sheet': 'Monitoring Sheet',
          'Monitoring Sheet': 'Monitoring Sheet',
          'Add Monitoring Sheet Day': 'Add Monitoring Sheet Day',
          "No Monitoring Sheet found": "No monitoring sheet found",
          'Update Monitoring Sheet Day': 'Update Monitoring Sheet Day',
          'Add Monitoring Sheet Day': 'Add Monitoring Sheet Day',
          'Update Monitoring Sheet Treatments':
              'Update Monitoring Sheet Treatments',
          'Medicine Requests': 'Medicine Requests',
          'Medicine Request': 'Medicine Request',
          'Medicine Quantity': 'Medicine Quantity',
          'Add Medicine Request': 'Add Medicine Request',
          'Edit Medicine Request': 'Edit Medicine Request',
          'Logout': 'Logout',
          'Home': 'Home',
          'Patients': 'Patients',
          // patient details
          'Name': 'Name',
          'First Name': 'First name',
          'Last Name': 'Last name',
          'First name is required': 'first name is required',
          'Last name is required': 'last name is required',
          'Gender': 'Gender',
          'Age': 'Age',
          'Address': 'Address',
          'Address is required': 'Address is required',
          'Phone Number': 'Phone number',
          'Phone number is required': 'Phone number is required',
          'Place of Birth': 'Place of birth',
          'Birth Date': 'Birth Date',
          'Birth date is required': 'Birth date is required',
          'Nationality': 'Nationality',
          'Nationality is required': 'Nationality is required',
          'Family Situation': 'Family situation',
          'No Family Situation': 'No family situation',
          'Emergency Contact Phone Number': 'Emergency contact phone number',
          'No Emergency Contact': 'No emergency contact',
          'Emergency Contact Name': 'Emergency contact name',
          'Today': 'Today',
          'Update': 'Update',
          'Edit': 'Edit',
          'Cancel': 'Cancel',

          'Delete': 'Delete',
          "Filled by": "Filled by",
          'Add': 'Add',
          'Save': 'Save',
          "Empty": "Empty",
          'Checkup': 'Checkup',
          'Result': 'Result',
          'Temperature': 'Temperature',
          'Blood Pressure': 'Blood Pressure',
          'Urine': 'Urine',
          'Weight': 'Weight',
          'Report': 'Report',
          'Treatments': 'Treatments',
          "Fill": "Fill",
          'Add Treatment': 'Add Treatment',
          'Dose': 'Dose',
          'Injection': 'injection',
          'Oral': 'Oral',
          'Topical': 'Topical',
          'Tablet': 'Tablet',
          'Syrup': 'Syrup',
          'Treatment Type': 'Treatment Type',
          'Update Treatments': 'Update Treatments',
          'Delete Treatment': 'Delete Treatment',
          'Are you sure you want to delete this treatment?':
              'Are you sure you want to delete this treatment?',

          'Are you sure you want to delete this complementary examination?':
              'Are you sure you want to delete this complementary examination?',
          'Delete Complementary Examination':
              'Delete Complementary Examination',
          'Are you sure you want to delete this medicine request?':
              'Are you sure you want to delete this medicine request?',
          "Are you sure you want to delete this image?":
              "Are you sure you want to delete this image?",

          'All': 'All',
          'Pending': 'Pending',
          'Approved': 'Approved',
          'Rejected': 'Rejected',
          'Quantity': 'Quantity',
          'Review': 'Review',
          'Created At': 'Created At',
          'Active only': 'Active only',
          'Main only': 'Mine only',
        },
        'AR': {
          'Patient' : 'المريض',

          'Log in': 'تسجيل الدخول',
          'Login to your account': 'تسجيل الدخول إلى حسابك',
          'Sign Out': 'تسجيل الخروج',
          'Welcome back': 'مرحباً بعودتك',"Welcome": "مرحباً",

          'Dashboard': 'لوحة التحكم',
          'Patients': 'المرضى',
          'My Patients': 'مرضاي',
          'My Medical Records': 'سجلاتي الطبية',
          'Doctor': 'الطبيب',
          'Login': 'تسجيل الدخول',
          'Patient Details': 'تفاصيل المريض',
          'Add Patient': 'إضافة مريض',
          'Edit Patient': 'تعديل بيانات المريض',
          'Search': 'بحث',
          "In Hospital Only": "في المستشفى فقط",
          'Day': 'يوم',
          'No': 'لا',
          'Yes': 'نعم',
//////////////////////////////////////////
          'Medical Record Details': 'تفاصيل السجل الطبي',
          'Medical Records': 'السجلات الطبية',
          'View Details': 'عرض التفاصيل',
          'Add Medical Record': 'إضافة سجل طبي',
          'Add New Medical Record': 'إضافة سجل طبي جديد',
          'Edit Medical Record': 'تعديل سجل طبي',
          "Show only active records": "عرض السجلات النشطة فقط",
          "Active": "نشط",
          "Closed": "مغلق",
          "Status": "الحالة",
          "Condition": "الحالة الصحية",
          'Other': 'أخرى',
          "infectious diseases": "الأمراض المعدية",
          "Patient Entering Date": "تاريخ دخول المريض",
          "Patient Entering Date is required":
          "تاريخ دخول المريض مطلوب",
          'Medicine': 'الدواء',
          "Patient Leaving Date": "تاريخ خروج المريض",
          "Medical Specialty": "التخصص الطبي",
          "Medical Specialty is required": "التخصص الطبي مطلوب",
          "Condition Description": "وصف الحالة الصحية",
          "Condition Description is required":
          "وصف الحالة الصحية مطلوب",
          "Bed Number": "رقم السرير",
          "Bed Number is required": "رقم السرير مطلوب",
          "Standard Treatment": "العلاج القياسي",
          "Standard Treatment is required": "العلاج القياسي مطلوب",
          "State Upon Enter": "الحالة عند الدخول",
          'State Upon Enter is required': "الحالة عند الدخول مطلوبة",
          "State Upon Exit": "الحالة عند الخروج",
          "Leaving Information": "معلومات الخروج",
          'Observations': 'ملاحظات',
          'Observation': 'ملاحظة',
          'Add Observation': 'إضافة ملاحظة',
          'Edit Observation': 'تعديل الملاحظة',
          "Add photo from camera": "إضافة صورة من الكاميرا",
          "Add photo from gallery": "إضافة صورة من المعرض",
          'Photos': 'الصور',
          'Date': 'التاريخ',
          'Complementary Examinations': 'الفحوصات المكملة',
          'Complementary Examination': 'الفحص المكمل',
          "No Complementary Examinations Found":
          "لم يتم العثور على فحوصات مكملة",
          'Add Complementary Examination': 'إضافة فحص مكمل',
          'Edit Complementary Examination': 'تعديل الفحص المكمل',
          'Monitoring Sheet': 'ورقة المراقبة',
          'Monitoring Sheets': 'أوراق المراقبة',
          'Add Monitoring Sheet Day': 'إضافة يوم في ورقة المراقبة',
          "No Monitoring Sheet found": "لم يتم العثور على ورقة مراقبة",
          'Update Monitoring Sheet Day': 'تحديث يوم في ورقة المراقبة',
          'Add Monitoring Sheet Day': 'إضافة يوم في ورقة المراقبة',
          'Update Monitoring Sheet Treatments':
          'تحديث علاجات في ورقة المراقبة',
          'Medicine Requests': 'طلبات الأدوية',
          'Medicine Request': 'طلب الدواء',
          'Medicine Quantity': 'كمية الدواء',
          'Add Medicine Request': 'إضافة طلب دواء',
          'Edit Medicine Request': 'تعديل طلب الدواء',
          'Logout': 'تسجيل الخروج',
          'Home': 'الرئيسية',
          'Patients': 'المرضى',
// patient details
          'Name': 'الاسم',
          'First Name': 'الاسم الأول',
          'Last Name': 'الاسم الأخير',
          'First name is required': 'الاسم الأول مطلوب',
          'Last name is required': 'الاسم الأخير مطلوب',
          'Gender': 'الجنس',
          'Age': 'العمر',
          'Address': 'العنوان',
          'Address is required': 'العنوان مطلوب',
          'Phone Number': 'رقم الهاتف',
          'Phone number is required': 'رقم الهاتف مطلوب',
          'Place of Birth': 'مكان الولادة',
          'Birth Date': 'تاريخ الولادة',
          'Birth date is required': 'تاريخ الولادة مطلوب',
          'Nationality': 'الجنسية',
          'Nationality is required': 'الجنسية مطلوبة',
          'Family Situation': 'الحالة العائلية',
          'No Family Situation': 'لا يوجد حالة عائلية',
          'Emergency Contact Phone Number': 'رقم هاتف جهة الاتصال الطارئة',
          'No Emergency Contact': 'لا يوجد جهة اتصال طارئة',
          'Emergency Contact Name': 'اسم جهة الاتصال الطارئة',
          'Today': 'اليوم',
          'Update': 'تحديث',
          'Edit': 'تعديل',
          'Cancel': 'إلغاء',
          'Delete': 'حذف',
          "Filled by": "مملوءة بواسطة",
          'Add': 'إضافة',
          'Save': 'حفظ',
          "Empty": "فارغة",
          'Checkup': 'فحص',
          'Result': 'النتيجة',
          'Temperature': 'درجة الحرارة',
          'Blood Pressure': 'ضغط الدم',
          'Urine': 'البول',
          'Weight': 'الوزن',
          'Report': 'تقرير',
          'Treatments': 'العلاجات',
          "Fill": "ملء",
          'Add Treatment': 'إضافة علاج',
          'Dose': 'الجرعة',
          'Injection': 'حقنة',
          'Tablet': 'حبة',
          'Syrup': 'شراب',
          'Treatment Type': 'نوع العلاج',
          'Update Treatments': 'تحديث العلاجات',
          'Delete Treatment': 'حذف العلاج',
          'Are you sure you want to delete this treatment?':
          'هل أنت متأكد من رغبتك في حذف هذا العلاج؟',

          'Are you sure you want to delete this complementary examination?':
          'هل أنت متأكد من رغبتك في حذف هذا الفحص الإضافي؟',
          'Delete Complementary Examination':
          'حذف الفحص الإضافي',
          'Are you sure you want to delete this medicine request?':
          'هل أنت متأكد من رغبتك في حذف طلب الدواء هذا؟',
          "Are you sure you want to delete this image?":
          "هل أنت متأكد من رغبتك في حذف هذه الصورة؟",

          'All': 'الكل',
          'Pending': 'معلق',
          'Approved': 'تم الموافقة',
          'Rejected': 'مرفوض',
          'Quantity': 'الكمية',
          'Review': 'مراجعة',
          'Created At': 'تم الإنشاء في',
          'Mine only': 'الخاصة بي فقط',
        }
      };
}